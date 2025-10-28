DROP TABLE product_.product_collection;

CREATE TABLE product_.product_collection (
  id VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  version VARCHAR NOT NULL,
  owner_name VARCHAR NOT NULL,
  products SUPER NOT NULL, -- Caching layer for product_collection_products that will be updated whenever product_collection_products is updated
  PRIMARY KEY(id)
);

CREATE TABLE product_.product_collection_attributes (
  product_collection_id VARCHAR SORTKEY NOT NULL,
  attribute_name VARCHAR NOT NULL,
  attribute_value VARCHAR NOT NULL,
  FOREIGN KEY(product_collection_id) REFERENCES product_.product_collection(id)
);