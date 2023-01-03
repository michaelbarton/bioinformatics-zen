#!/usr/bin/env python3

import re
import textwrap

import click


def convert_link(document: str, src_image_dir: str, dst_image_url: str) -> str:

    matches = re.finditer(r'^!\[(.*?)\]\((.+?)\)$', document, flags=re.MULTILINE | re.DOTALL)
    for match in matches:
        description, link = match.group(1), match.group(2)

        # Remap the rmarkdown locations to s3 locations
        if src_image_dir not in link:
            raise ValueError(f'Image directory {src_image_dir} not found in image link: "{link}"')

        url = link.replace(src_image_dir, dst_image_url)

        if not description:
            raise ValueError(f'Image description not found for image link: "{link}"')

        # If there are multiple sentences in the description, then make the first sentence the bolded text
        # and the rest the longer description.
        fields = description.strip().split('.', 1)

        args = {
            "url": url,
            "anchor": '',
            "short_desc": fields[0].strip().replace("\n", " ") + "."
        }
        if fields[1]:
            args["long_desc"] = fields[1].strip().replace("\n", " ")

        arg_str =  ', '.join(f"{k}: '{v}'" for k, v in args.items())

        # Create the new link
        nunjucks_link = textwrap.dedent(f"""\
        {{% include 'image_with_caption.njk', 
            {arg_str}
        %}}""")

        document = document.replace(match.group(0), nunjucks_link)
    return document




@click.command("Convert RMarkdown output to nujucks markdown.")
@click.argument("input_file", type=click.Path(exists=True, file_okay=True, dir_okay=False), required=True)
@click.argument("output_file", type=click.Path(exists=False, file_okay=True, dir_okay=False), required=True)
# TODO: Change back exists=False
@click.option("--src-image-dir", type=click.Path(exists=False, file_okay=False, dir_okay=True), required=True)
@click.option("--dst-image-url", type=str, required=True)
@click.option("--lede", is_flag=True)
def main(input_file: str, output_file: str, src_image_dir: str, dst_image_url: str, lede: bool = False) -> None:
    with open(input_file, "rt") as fh_in:
        transform = convert_link(fh_in.read(), src_image_dir, dst_image_url)

    # If this article has a lede, then add the lede markdown container
    if lede:
        paragraphs = transform.split("\n\n")
        paragraphs[0] = f":::lede\n{paragraphs[0]}\n:::\n"
        transform = "\n\n".join(paragraphs)

    with open(output_file, "wt") as fh_out:
        fh_out.write(transform)


if __name__ == "__main__":
    main()
