UPDATE TABLE product_.product_collection ADD COLUMN owner_name VARCHAR NOT NULL;
UPDATE TABLE product_.product_collection ADD COLUMN version VARCHAR NOT NULL,

CREATE TABLE product_.product_collection_attributes (
  product_collection_id VARCHAR SORTKEY NOT NULL,
  attribute_name VARCHAR NOT NULL,
  attribute_value VARCHAR NOT NULL,
  FOREIGN KEY(product_collection_id) REFERENCES product_.product_collection(id)
);