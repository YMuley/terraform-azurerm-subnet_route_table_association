# #------------- Data source from subscription
data "azurerm_subnet" "subnet" {
  for_each       = local.route_table
  name           = each.value.subnet_name
  virtual_network_name  = each.value.virtual_network_name
  resource_group_name   = each.value.resource_group_name
}
# #----------- Route Table - Virtual Network Association
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  for_each       = local.route_table
  route_table_id = var.route_table_output[each.value.route_table_name].id
  subnet_id      = data.azurerm_subnet.subnet[format("%s-%s-%s", each.value.route_table_name, each.value.virtual_network_name, each.value.subnet_name)].id#[for subnet in data.azurerm_subnet.subnet: subnet.id if subnet.name == each.value.subnet_name]  #var.subnet_output[format("%s/%s", each.value.virtual_network_name, each.value.subnet_name)].id
  depends_on = [ data.azurerm_subnet.subnet ]
}
