-- CREATE TEMPORARY TABLE "QGG13Heroes" (
--     "Name" TEXT NOT NULL);

INSERT OR IGNORE INTO QGG13Heroes(Name) VALUES
('DELIVERANCE'),
('REALME'),
('DISCIPLINE'),
('GOLD'),
('HELIX'),
('DECIMATION'),
('BODHI'),
('SETSUNA'),
('DAYBREAK'),
('INFINITY'),
('STARS'),
('VICISSITUDE'),
('REVERIE');

-- CREATE TEMPORARY TABLE "QGG13HeroesBuildings" (
-- 		"BuildingType" TEXT NOT NULL,
-- 		"Name" TEXT NOT NULL,
--         "Description" TEXT,
-- 		"MaxPlayerInstances" INTEGER NOT NULL DEFAULT -1,
--         "PrereqDistrict" TEXT,
--         "PurchaseYield" TEXT,
-- 		"Cost" INTEGER NOT NULL,
--         "AdvisorType" TEXT,
-- 		"Entertainment" INTEGER NOT NULL DEFAULT 0,
-- 		"Maintenance" INTEGER NOT NULL DEFAULT 0,
-- 		"TraitType" TEXT,
-- 		"RegionalRange" INTEGER NOT NULL DEFAULT 0);

INSERT OR IGNORE INTO Types(Type,Kind) VALUES
 ('TRAIT_LEADER_QGG_HOH_ELYSIA_BUILDINGS','KIND_TRAIT');

INSERT OR IGNORE INTO Traits(TraitType) VALUES
('TRAIT_LEADER_QGG_HOH_ELYSIA_BUILDINGS');

INSERT OR IGNORE INTO LeaderTraits(LeaderType,TraitType) VALUES
('LEADER_QGG_HOH_ELYSIA','TRAIT_LEADER_QGG_HOH_ELYSIA_BUILDINGS');

INSERT OR IGNORE INTO QGG13HeroesBuildings(BuildingType,Name,Description,MaxPlayerInstances,PrereqDistrict,PurchaseYield,Cost,AdvisorType,Entertainment,Maintenance,TraitType,RegionalRange)
SELECT 'BUILDING_QGG_HOH_ELYSIA_'||Name,'LOC_BUILDING_QGG_HOH_ELYSIA_'||Name||'_NAME','LOC_BUILDING_QGG_HOH_ELYSIA_'||Name||'_DESCRIPTION',1,'DISTRICT_QGG_HOH_ELYSIA','YIELD_GOLD','220','ADVISOR_TECHNOLOGY',1,0,'TRAIT_LEADER_QGG_HOH_ELYSIA_BUILDINGS',12
FROM QGG13Heroes WHERE Name!='REALME';

INSERT OR IGNORE INTO Types(Type,Kind)
SELECT BuildingType,'KIND_BUILDING' FROM QGG13HeroesBuildings;

INSERT OR IGNORE INTO Buildings(BuildingType,Name,Description,MaxPlayerInstances,PrereqDistrict,PurchaseYield,Cost,AdvisorType,Entertainment,Maintenance,TraitType,RegionalRange)
SELECT BuildingType,Name,Description,MaxPlayerInstances,PrereqDistrict,PurchaseYield,Cost,AdvisorType,Entertainment,Maintenance,TraitType,RegionalRange
FROM QGG13HeroesBuildings;

INSERT OR IGNORE INTO Building_YieldChanges(BuildingType,YieldType,YieldChange)
SELECT QGG13HeroesBuildings.BuildingType,Yields.YieldType,1
FROM QGG13HeroesBuildings,Yields;

INSERT OR IGNORE INTO MutuallyExclusiveBuildings(Building,MutuallyExclusiveBuilding)
SELECT A.BuildingType,B.BuildingType
FROM QGG13HeroesBuildings A,QGG13HeroesBuildings B WHERE A.BuildingType!=B.BuildingType;

-- DELETE FROM DistrictModifiers
-- WHERE ModifierId IN (
--     SELECT 'BONUS_HOH_DISTRICT_GREATPERSON_POINTS_' || DistrictType || '_' || GreatPersonClassType
--     FROM District_GreatPersonPoints
--     WHERE EXISTS (SELECT DistrictType FROM Districts WHERE (Districts.TraitType IS NULL AND District_GreatPersonPoints.DistrictType = Districts.DistrictType))
-- );


-- -- 为每种区域类型和对应的伟人类别创建ModifierId
-- insert or ignore into DistrictModifiers (DistrictType, ModifierId) 
-- SELECT DistrictType, 'BONUS_HOH_DISTRICT_GREATPERSON_POINTS_' || DistrictType || '_' || GreatPersonClassType
-- FROM District_GreatPersonPoints;

-- -- 创建Modifiers
-- insert or ignore into Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
-- SELECT 'BONUS_HOH_DISTRICT_GREATPERSON_POINTS_' || DistrictType || '_' || GreatPersonClassType, 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 0, 0, 0, NULL, 'RS_QGG_HOH_DISTRICT_IS_7POP_' || DistrictType
-- FROM District_GreatPersonPoints;

-- -- 创建ModifierArguments
-- -- 为每个ModifierId添加伟人点数加成
-- insert or ignore into ModifierArguments (ModifierId, Name, Value) 
-- SELECT 'BONUS_HOH_DISTRICT_GREATPERSON_POINTS_' || DistrictType || '_' || GreatPersonClassType, 'Amount', '1' 
-- FROM District_GreatPersonPoints;

-- -- 为每个ModifierId指定伟人类别
-- insert or ignore into ModifierArguments (ModifierId, Name, Value) 
-- SELECT 'BONUS_HOH_DISTRICT_GREATPERSON_POINTS_' || DistrictType || '_' || GreatPersonClassType, 'GreatPersonClassType', GreatPersonClassType
-- FROM District_GreatPersonPoints;

-- 创建RequirementSets和Requirements
-- 这里假设RequirementSets和Requirements的设置不会因区域类型而变化
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) 
SELECT 'RS_QGG_HOH_DISTRICT_IS_7POP_' || DistrictType, 'REQUIREMENTSET_TEST_ALL' 
FROM District_GreatPersonPoints;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
SELECT 'RS_QGG_HOH_DISTRICT_IS_7POP_' || DistrictType, 'REQ_QGG_HOH_DISTRICT_IS_' || DistrictType
FROM District_GreatPersonPoints;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
SELECT 'RS_QGG_HOH_DISTRICT_IS_7POP_' || DistrictType, 'REQ_QGG_HOH_HAS_7_POP'
FROM District_GreatPersonPoints;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
SELECT 'RS_QGG_HOH_DISTRICT_IS_7POP_' || DistrictType, 'REQ_LEADER_IS_HOH_ELISIA'
FROM District_GreatPersonPoints;

-- 创建District的Requirements
insert or ignore into Requirements (RequirementId, RequirementType) 
SELECT 'REQ_QGG_HOH_DISTRICT_IS_' || DistrictType, 'REQUIREMENT_DISTRICT_TYPE_MATCHES'
FROM District_GreatPersonPoints;

insert or ignore into RequirementArguments (RequirementId, Name, Value)  
SELECT 'REQ_QGG_HOH_DISTRICT_IS_' || DistrictType, 'DistrictType', DistrictType
FROM District_GreatPersonPoints;

insert or ignore into Requirements (RequirementId, RequirementType) VALUES 
('REQ_QGG_HOH_HAS_7_POP', 'REQUIREMENT_CITY_HAS_X_POPULATION');

insert or ignore into RequirementArguments (RequirementId, Name, Value) VALUES 
('REQ_QGG_HOH_HAS_7_POP', 'Amount', '7');


DELETE FROM Modifiers
WHERE ModifierId IN (
    SELECT 'BONUS_HOH_WONDER_BONUS_' || BuildingType || '_' || YieldType
    FROM Buildings, Yields
    WHERE Buildings.IsWonder = "1"
);
DELETE FROM ModifierArguments
WHERE ModifierId IN (
    SELECT 'BONUS_HOH_WONDER_BONUS_' || BuildingType || '_' || YieldType
    FROM Buildings, Yields
    WHERE Buildings.IsWonder = "1"
);

INSERT OR IGNORE INTO TraitModifiers(TraitType,ModifierId) VALUES
('TRAIT_CIVILIZATION_HOH_ELYSIAN_REALM','HOH_BUILDING_BONUS');


insert or IGNORE into Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
('HOH_BUILDING_BONUS' , 'MODIFIER_PLAYER_ADJUST_PROPERTY', 0, 0, 0, NULL, NULL);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('HOH_BUILDING_BONUS', 'Key', 'HOH_BUILDING_BONUS_PROPERTY');


