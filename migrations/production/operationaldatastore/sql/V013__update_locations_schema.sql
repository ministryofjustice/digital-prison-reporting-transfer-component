ALTER TABLE prisons.locationsinsideprison_location DROP COLUMN certification_id;
ALTER TABLE prisons.locationsinsideprison_location ADD COLUMN certified_cell boolean;
