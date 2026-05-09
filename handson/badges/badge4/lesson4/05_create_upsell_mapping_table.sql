create
or replace table ZENAS_ATHLEISURE_DB.PRODUCTS.upsell_mapping(
    sweatsuit_color_or_style varchar(25),
    upsell_product_code varchar(10)
);

insert into
    ZENAS_ATHLEISURE_DB.PRODUCTS.UPSELL_MAPPING(
        sweatsuit_color_or_style,
        upsell_product_code
    )
values
    ('Charcoal Grey', 'SWT_GRY'),('Forest Green', 'SWT_FGN'),('Orange', 'SWT_ORG'),('Pink', 'SWT_PNK'),('Red', 'SWT_RED'),('Yellow', 'SWT_YLW');