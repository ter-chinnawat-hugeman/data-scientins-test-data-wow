CREATE TABLE country (
    id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          varchar,
    created_date  timestamp,
    updated_date  timestamp
);

CREATE TABLE return_reason (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description  varchar
);

CREATE TABLE category (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         varchar,
    description  varchar,
    created_date timestamp,
    updated_date timestamp
);


CREATE TABLE supplier (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         varchar,
    address      varchar,
    country      integer NOT NULL,
    created_date timestamp,
    updated_date timestamp,
    is_active    boolean,
    reason       varchar,
    CONSTRAINT fk_supplier_country
        FOREIGN KEY (country) REFERENCES country (id)
);

CREATE TABLE warehouse (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         varchar,
    address      varchar,
    country      integer NOT NULL,
    created_date timestamp,
    updated_date timestamp,
    CONSTRAINT fk_warehouse_country
        FOREIGN KEY (country) REFERENCES country (id)
);


CREATE TABLE product (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         varchar,
    supplier     integer NOT NULL,
    price        float,
    description  varchar,
    category     integer NOT NULL,
    created_date timestamp,
    updated_date timestamp,
    is_active    boolean,
    reason       varchar,
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier) REFERENCES supplier (id),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category) REFERENCES category (id)
);


CREATE TABLE inventory (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product      integer NOT NULL,
    warehouse    integer NOT NULL,
    quantity     integer,
    incoming     integer,
    outgoing     integer,
    created_date timestamp,
    updated_date timestamp,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product) REFERENCES product (id),
    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (warehouse) REFERENCES warehouse (id)
);


CREATE TABLE transaction (
    id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cust_id       integer,
    created_date  timestamp,
    updated_date  timestamp,
    complete      boolean,
    complete_date timestamp
);


CREATE TABLE transaction_row (
    id             integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_id integer NOT NULL,
    product_id     integer NOT NULL,
    quantity       float,
    price          float,
    discount       float,
    total_price    float,
    created_date   timestamp,
    updated_date   timestamp,
    complete       boolean,
    return_reason  integer,
    CONSTRAINT fk_tranrow_transaction
        FOREIGN KEY (transaction_id) REFERENCES transaction (id),
    CONSTRAINT fk_tranrow_product
        FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT fk_tranrow_return_reason
        FOREIGN KEY (return_reason) REFERENCES return_reason (id)
);