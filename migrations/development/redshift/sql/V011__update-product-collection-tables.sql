DROP TABLE product_.product_collection_products;
DROP TABLE product_.product_collection;
DROP TABLE product_.product_collection_attributes;

CREATE TABLE product_.product_collection (
  id VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  version VARCHAR NOT NULL,
  owner_name VARCHAR NOT NULL,
  PRIMARY KEY(id)
) DISTSTYLE KEY DISTKEY(id);

CREATE TABLE product_.product_collection_products (
  product_collection_id VARCHAR SORTKEY NOT NULL,
  product_id VARCHAR NOT NULL,
  FOREIGN KEY(product_collection_id) REFERENCES product_.product_collection(id)
) DISTSTYLE KEY DISTKEY(product_collection_id);

CREATE TABLE product_.product_collection_attributes (
  product_collection_id VARCHAR SORTKEY NOT NULL,
  attribute_name VARCHAR NOT NULL,
  attribute_value VARCHAR NOT NULL,
  FOREIGN KEY(product_collection_id) REFERENCES product_.product_collection(id)
) DISTSTYLE KEY DISTKEY(id);