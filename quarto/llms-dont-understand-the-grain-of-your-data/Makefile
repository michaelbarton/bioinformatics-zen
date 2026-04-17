DB   = data/olist.duckdb
CSVS = csvs/olist_orders_dataset.csv

.PHONY: all clean

all: $(DB)

$(CSVS):
	mkdir -p csvs
	curl -L -o /tmp/brazilian-ecommerce.zip \
	  https://www.kaggle.com/api/v1/datasets/download/olistbr/brazilian-ecommerce
	unzip -j /tmp/brazilian-ecommerce.zip -d csvs

$(DB): setup_db.sql $(CSVS)
	mkdir -p data
	uv run python -c "import duckdb; duckdb.connect('$(DB)').execute(open('setup_db.sql').read())"

clean:
	rm -rf csvs $(DB)
