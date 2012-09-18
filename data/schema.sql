USE `speck` ;

-- -----------------------------------------------------
-- Table `speck`.`catalog_product_type`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_type` (
  `product_type_id` INT NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`product_type_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`company`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`company` (
  `company_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL DEFAULT NULL ,
  `email` VARCHAR(255) NULL DEFAULT NULL ,
  `phone` VARCHAR(255) NULL DEFAULT NULL ,
  `search_data` TEXT NOT NULL ,
  PRIMARY KEY (`company_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product` (
  `product_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `description` TEXT NULL DEFAULT NULL ,
  `product_type_id` INT NOT NULL DEFAULT 1 ,
  `item_number` VARCHAR(45) NULL DEFAULT NULL ,
  `manufacturer_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`product_id`) ,
  INDEX `fk_product_product_type_id_idx` (`product_type_id` ASC) ,
  INDEX `fk_catalog_product_1_idx` (`manufacturer_id` ASC) ,
  CONSTRAINT `fk_product_product_type_id`
    FOREIGN KEY (`product_type_id` )
    REFERENCES `speck`.`catalog_product_type` (`product_type_id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_product_manufacturer_company_id`
    FOREIGN KEY (`manufacturer_id` )
    REFERENCES `speck`.`company` (`company_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product_uom`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_uom` (
  `uom_code` CHAR(2) NOT NULL DEFAULT 'EA' ,
  `product_id` INT NOT NULL ,
  `price` DECIMAL(15,5) NOT NULL ,
  `retail` DECIMAL(15,5) NOT NULL ,
  `quantity` INT NOT NULL ,
  `sort_weight` INT NOT NULL DEFAULT 0 ,
  INDEX `fk_catalog_product_uom_uom_code_idx` (`uom_code` ASC) ,
  INDEX `fk_catalog_product_uom_product_id_idx` (`product_id` ASC) ,
  PRIMARY KEY (`uom_code`, `product_id`, `quantity`) ,
  CONSTRAINT `fk_catalog_product_uom_uom_code`
    FOREIGN KEY (`uom_code` )
    REFERENCES `speck`.`ansi_uom` (`uom_code` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_catalog_product_uom_product_id`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_availability`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_availability` (
  `product_id` INT NOT NULL ,
  `uom_code` CHAR(2) NOT NULL ,
  `distributor_id` INT UNSIGNED NOT NULL ,
  `cost` DECIMAL(15,5) NOT NULL ,
  `quantity` INT NOT NULL ,
  PRIMARY KEY (`product_id`, `uom_code`, `distributor_id`, `quantity`) ,
  INDEX `fk_catalog_availability_product_uom_idx` (`product_id` ASC, `uom_code` ASC, `quantity` ASC) ,
  INDEX `fk_catalog_availability_1_idx` (`distributor_id` ASC) ,
  CONSTRAINT `fk_catalog_availability_product_uom`
    FOREIGN KEY (`product_id` , `uom_code` , `quantity` )
    REFERENCES `speck`.`catalog_product_uom` (`product_id` , `uom_code` , `quantity` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_availability_distributor`
    FOREIGN KEY (`distributor_id` )
    REFERENCES `speck`.`company` (`company_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_category` (
  `category_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `seo_title` VARCHAR(255) NULL DEFAULT NULL ,
  `description_html` TEXT NULL DEFAULT NULL ,
  `image_file_name` VARCHAR(255) NULL ,
  PRIMARY KEY (`category_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_category_website`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_category_website` (
  `category_id` INT NOT NULL ,
  `parent_category_id` INT NULL ,
  `website_id` INT NULL ,
  INDEX `fk_catalog_category_linker_category_id_idx` (`category_id` ASC) ,
  INDEX `fk_catalog_category_linker_parent_category_id_idx` (`parent_category_id` ASC) ,
  INDEX `fk_catalog_category_linker_website_id_idx` (`website_id` ASC) ,
  UNIQUE INDEX `category_id_parent_category_id_website_id_uq` (`category_id` ASC, `parent_category_id` ASC, `website_id` ASC) ,
  CONSTRAINT `fk_catalog_category_linker_category_id`
    FOREIGN KEY (`category_id` )
    REFERENCES `speck`.`catalog_category` (`category_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_catalog_category_linker_parent_category_id`
    FOREIGN KEY (`parent_category_id` )
    REFERENCES `speck`.`catalog_category` (`category_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_catalog_category_linker_website_id`
    FOREIGN KEY (`website_id` )
    REFERENCES `speck`.`website` (`website_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_category_product`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_category_product` (
  `category_id` INT NOT NULL ,
  `product_id` INT NOT NULL ,
  `website_id` INT NOT NULL ,
  `image_file_name` VARCHAR(45) NULL ,
  INDEX `fk_catalog_product_category_linker_category_id_idx` (`category_id` ASC) ,
  INDEX `fk_catalog_product_category_linker_product_id_idx` (`product_id` ASC) ,
  PRIMARY KEY (`product_id`, `category_id`, `website_id`) ,
  INDEX `fk_catalog_product_category_linker_website_id_idx` (`website_id` ASC) ,
  CONSTRAINT `fk_catalog_product_category_linker_category_id`
    FOREIGN KEY (`category_id` )
    REFERENCES `speck`.`catalog_category` (`category_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_product_category_linker_product_id`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_product_category_linker_website_id`
    FOREIGN KEY (`website_id` )
    REFERENCES `speck`.`website` (`website_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_option`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_option` (
  `option_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `instruction` VARCHAR(255) NULL DEFAULT NULL ,
  `required` TINYINT(1) NOT NULL DEFAULT 0 ,
  `variation` TINYINT NOT NULL DEFAULT 0 ,
  `option_type_id` TINYINT(1) NULL ,
  PRIMARY KEY (`option_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_choice`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_choice` (
  `choice_id` INT NOT NULL AUTO_INCREMENT ,
  `product_id` INT NULL ,
  `option_id` INT NOT NULL ,
  `price_override_fixed` DECIMAL(15,5) NOT NULL DEFAULT 0 ,
  `price_discount_fixed` DECIMAL(15,5) NOT NULL DEFAULT 0 ,
  `price_discount_percent` DECIMAL(5,2) NOT NULL DEFAULT 0 ,
  `price_no_charge` TINYINT(1) NOT NULL DEFAULT 0 ,
  `override_name` VARCHAR(255) NULL DEFAULT NULL ,
  `sort_weight` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`choice_id`) ,
  INDEX `fk_catalog_choice_product_id_idx` (`product_id` ASC) ,
  INDEX `fk_catalog_choice_option_id_idx` (`option_id` ASC) ,
  CONSTRAINT `fk_catalog_choice_product_id`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_choice_option_id`
    FOREIGN KEY (`option_id` )
    REFERENCES `speck`.`catalog_option` (`option_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = DEFAULT;


-- -----------------------------------------------------
-- Table `speck`.`catalog_choice_option`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_choice_option` (
  `option_id` INT(11) NOT NULL ,
  `choice_id` INT(11) NOT NULL ,
  `sort_weight` INT(11) NOT NULL DEFAULT '0' ,
  INDEX `UNIQUE` (`choice_id` ASC, `option_id` ASC) ,
  INDEX `fk_catalog_choice_option_linker_1_idx` (`option_id` ASC) ,
  INDEX `fk_catalog_choice_option_linker_2_idx` (`choice_id` ASC) ,
  CONSTRAINT `fk_catalog_choice_option_linker_1`
    FOREIGN KEY (`option_id` )
    REFERENCES `speck`.`catalog_option` (`option_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_choice_option_linker_2`
    FOREIGN KEY (`choice_id` )
    REFERENCES `speck`.`catalog_choice` (`choice_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'the options that choices have\n(linker table names are parent' /* comment truncated */;


-- -----------------------------------------------------
-- Table `speck`.`catalog_option_image`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_option_image` (
  `image_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `option_id` INT(11) NOT NULL ,
  `sort_weight` INT(11) NOT NULL DEFAULT '0' ,
  `file_name` VARCHAR(45) NULL ,
  `label` VARCHAR(255) NULL ,
  PRIMARY KEY (`image_id`) ,
  INDEX `fk_catalog_option_image_1_idx` (`option_id` ASC) ,
  CONSTRAINT `fk_catalog_option_image_1`
    FOREIGN KEY (`option_id` )
    REFERENCES `speck`.`catalog_option` (`option_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product_document`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_document` (
  `document_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `product_id` INT(11) NOT NULL ,
  `sort_weight` INT(11) NOT NULL DEFAULT '0' ,
  `file_name` VARCHAR(45) NULL ,
  `label` VARCHAR(45) NULL ,
  INDEX `linker_id` (`document_id` ASC) ,
  PRIMARY KEY (`document_id`) ,
  INDEX `fk_catalog_product_document_1_idx` (`product_id` ASC) ,
  CONSTRAINT `fk_catalog_product_document_1`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product_image`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_image` (
  `image_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `product_id` INT(11) NOT NULL ,
  `sort_weight` INT(11) NOT NULL DEFAULT '0' ,
  `file_name` VARCHAR(45) NULL ,
  `label` VARCHAR(255) NULL ,
  INDEX `linker_id` (`image_id` ASC) ,
  PRIMARY KEY (`image_id`) ,
  INDEX `fk_catalog_product_image_1_idx` (`product_id` ASC) ,
  CONSTRAINT `fk_catalog_product_image_1`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product_option`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_option` (
  `product_id` INT NULL ,
  `option_id` INT NULL ,
  `sort_weight` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`product_id`, `option_id`) ,
  INDEX `fk_catalog_product_option_linker_product_id_idx` (`product_id` ASC) ,
  INDEX `fk_catalog_product_option_linker_option_id_idx` (`option_id` ASC) ,
  CONSTRAINT `fk_catalog_product_option_linker_product_id`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_catalog_product_option_linker_option_id`
    FOREIGN KEY (`option_id` )
    REFERENCES `speck`.`catalog_option` (`option_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `speck`.`catalog_product_spec`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `speck`.`catalog_product_spec` (
  `spec_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `product_id` INT(11) NOT NULL ,
  `label` VARCHAR(255) NULL DEFAULT NULL ,
  `value` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`spec_id`) ,
  INDEX `fk_catalog_product_spec_1_idx` (`product_id` ASC) ,
  CONSTRAINT `fk_catalog_product_spec_1`
    FOREIGN KEY (`product_id` )
    REFERENCES `speck`.`catalog_product` (`product_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Data for table `speck`.`catalog_product_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `speck`;
INSERT INTO `speck`.`catalog_product_type` (`product_type_id`, `name`) VALUES (1, 'Shell');
INSERT INTO `speck`.`catalog_product_type` (`product_type_id`, `name`) VALUES (2, 'Product');

COMMIT;
