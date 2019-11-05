public class ChildsComponentController {
    @AuraEnabled	
    public static Map<String,Integer> getChildsMap(String rId) {
        //Id sId = '0017F000009SJFG';
        Id recordId = rId;
        String sobjectType = recordId.getSObjectType().getDescribe().getName();
        List<Schema.ChildRelationship> childs = recordId.getSObjectType().getDescribe().getChildRelationships();
        System.debug('childs = ' + childs);
        
        Integer count = 1;
        Integer countAll = 1;
        List<String> childFields = new List<String>();
        Map<String, Integer> resultMap = new Map<String,Integer>();
        
        for (Schema.ChildRelationship rel:childs) {
            if (rel.getRelationshipName() != null && rel.getRelationshipName() != 'null' 
                && rel.getRelationshipName() != 'RelatedObjects' ) {
                    childFields.add(rel.getRelationshipName());
                    count++;
                    countAll++;
                    if (count == 20 || countAll == childs.size()) {//Max number of nested queries 20                        
                        String query = 'Select ';
                        for(String field:childFields) {
                            query += ' (Select Id From '+ field + ')' + ',';
                        }
                        query = query.substring(0, query.length() -1);//remove excessive ","
                        query += ' From ' + sobjectType + ' Where Id = \'' + recordId + '\' Limit 1';
                        
                        sObject result =  database.query(query);
                        for (String field:childFields) {
                            if (result.getSObjects(field)!= null) {                                
                                resultMap.put(field,result.getSObjects(field).size());                            
                            }
                        }
                        count = 1;
                        childFields.clear();
                    }                    
            }
        }
        System.debug('resultMap = ' + resultMap);
        return resultMap;
    }
}