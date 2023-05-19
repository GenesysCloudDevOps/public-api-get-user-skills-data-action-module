resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "pageNumber" = {
                "default" = "1",
                "type" = "integer"
            },
            "userId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "pageCount" = {
                "type" = "integer"
            },
            "skillNames" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "skillProficiencies" = {
                "items" = {
                    "type" = "number"
                },
                "type" = "array"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/users/$${input.userId}/routingskills?pageSize=100&pageNumber=$${input.pageNumber}"
        
    }

    config_response {
        success_template = "{ \"skillProficiencies\": $${proficiencies}, \"skillNames\": $${names}, \"pageCount\": $${pageCount} }"
        translation_map = { 
			pageCount = "$.pageCount"
			names = "$.entities..name"
			proficiencies = "$.entities..proficiency"
		}
        translation_map_defaults = {       
			pageCount = "0"
			names = "[]"
			proficiencies = "[]"
		}
    }
}