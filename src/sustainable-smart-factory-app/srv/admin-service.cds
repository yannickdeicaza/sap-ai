using {sap.smartfactory as sqi} from '../db/sqi-data-model';
using {sap.smartfactory as pdm} from '../db/pdm-data-model';

//service AdminService @(requires:'admin') {
service AdminService {
  entity CVQualityRecords     as projection on sqi.CVQualityRecords actions {
    @sap.applicable.path : 'cvInference'
    @(
      cds.odata.bindingparameter.name : '_it',
      Common.SideEffects              : {TargetProperties : [
        '_it/confidence',
        '_it/qualityLabel',
        '_it/detectedAt',
        '_it/segmentedImage',
        '_it/successInference',
        '_it/defectedPerc',
        '_it/defectiveDesc',
        '_it/defectiveDiscount'
      ]}
    )
    action inferenceImageCV();
  };

  entity DefectiveProductPrices  as projection on sqi.DefectiveProductPrices;

  entity PlantEquipmentStatus as projection on pdm.PlantEquipmentStatus;
  entity PlantConditions      as projection on pdm.PlantConditions;
  entity Equipments           as projection on pdm.Equipments;

  // @Capabilities: {
  //   UpdateRestrictions.Updatable: true
  // }
  entity EquipmentConditions  as
    select from pdm.EquipmentConditions {
      *,
      // equipment.NR as equipment,
      // equipment.name as equipmentName,
      // equipment.plant as plant,
      // equipment.plantSection as plantSection,
      // equipment.funcLocation as funcLocation,
      
      @Core.Computed
      count(
        anomalies.ID
      ) as numberOfAnomalies : Integer,
    }
    group by
      ID,
      createdAt,
      createdBy,
      modifiedAt,
      modifiedBy,
      plantCond.ID,
      equipment.NR,
      toEquipmentStatus.code,
      recStartedAt,
      recEndedAt,
      date,
      followUpDocType,
      followUpDocNum,
      maintenanceCost,
      currency.code
    actions {
      @sap.applicable.path : 'moCreated'
      @(
        cds.odata.bindingparameter.name : '_it',
        Common.SideEffects              : {TargetProperties : [
          '_it/followUpDocNum',
          '_it/followUpDocType'
        ]}
      )
      action createMO();
    };

  entity Anomalies            as projection on pdm.Anomalies actions {
    @sap.applicable.path : 'anomalyInference'
    @(
      cds.odata.bindingparameter.name : '_it',
      Common.SideEffects              : {TargetProperties : [
        '_it/confidence',
        '_it/status',
        '_it/detectedAt',
        '_it/anomalyType_code'
      ]}
    )
    action inferenceSoundAnomaly();
  };

  entity AnomalyTypes         as projection on pdm.AnomalyTypes;
}
