variable "connection_policies" {
  description = "A list of lists with connection policies"
  type        = list(list(string))
  default     = []
  nullable    = false

  validation {
    condition = alltrue(
      [for entry in var.connection_policies : length(entry) == 2]
    ) || var.connection_policies == []
    error_message = "Invalid formatting. A list of lists is expected, with the embedded lists of length of exactly 2 network domains. e.g. [ [\"one\", \"two\"], [\"one\", \"three\"] ]."
  }
}

variable "manage_network_domains" {
  description = "Determines whether this module is responsible for creating network domains"
  type        = bool
  default     = true
  nullable    = false
}

variable "associations" {
  description = "A map with network domain associations"
  type        = map(map(string))
  default     = {}
  nullable    = false
}

variable "additional_domains" {
  description = "A list of network domains to be created, for which there are no connection policies defined (yet)"
  type        = list(string)
  default     = []
  nullable    = false
}

locals {
  network_domain_list = (
    sort(       #Make sure the list always follows the same sequence
      distinct( #Make sure there are no double entries in the list
        concat( #Get all values from connection_policies and combine them with additional_domains to one list
          flatten(var.connection_policies),
          var.additional_domains,
        )
      )
    )
  )

  unique_connection_policies = (
    #Make sure no reverse and double polcies exist
    setunion([for item in var.connection_policies : sort(item)])
  )

  #Create an object that a for_each loop can handle (map)
  connection_policies_object = { for entry in local.unique_connection_policies : format("%s:%s", entry[0], entry[1]) => entry }
}
