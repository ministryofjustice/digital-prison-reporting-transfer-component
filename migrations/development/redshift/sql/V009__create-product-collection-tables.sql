CREATE TABLE product_.product_collection (
  id VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  products SUPER NOT NULL, -- Caching layer for product_collection_products that will be updated whenever product_collection_products is updated
  PRIMARY KEY(id)
);
CREATE TABLE product_.product_collection_products (
  product_collection_id VARCHAR SORTKEY NOT NULL,
  product_id VARCHAR NOT NULL,
  FOREIGN KEY(product_collection_id) REFERENCES product_collection(id)
);