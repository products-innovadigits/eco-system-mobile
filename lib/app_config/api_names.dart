
abstract class ApiNames{

  static const LOGIN = "login" ;
  static const DASHBOARD = "landlord_summaries" ;
  static properties(userId) => "landlords/$userId/properties" ;
  static propertyInfo(userId , propertyId) => "landlords/$userId/properties/$propertyId" ;
  static propertyStatus(propertyId) => "properties/$propertyId" ;
  static const PROPERTY_STATUS =  "properties/propertyStatus" ;
  static propertyUnits(propertyId) => "properties/$propertyId/units" ;
  static propertyLeases(propertyId) => "properties/$propertyId/leases" ;
  static propertyInvoices(propertyId) => "properties/$propertyId/invoices" ;
  static propertyNotices(propertyId) => "properties/$propertyId/notices" ;
  static invoices(userId) => "landlords/$userId/invoices";
  static leaseInvoices(leaseId) => "leases/$leaseId/invoices";
  static unitInfo(unitId) => "units/$unitId";
  static unitStatus(unitId) => "units/$unitId/unitStatus";
  static unitLeases(unitId) => "units/$unitId/leases";
  static unitPayment(unitId) => "landlords/unit/$unitId/payments";
  static unitInvoices(unitId) => "units/$unitId/invoices";
  static const APPROVED = "payments/approve" ;
  static const CANCEL = "payments/cancel" ;
  static const RECEIPT = "payments/receipt" ;
  static const TENANTS = "tenants/search" ;
  static  payments(userId) => "landlords/$userId/payments" ;
   static  const ADD_PAYMENT = "payments" ;
  static const PAYMENTS_ATTACH = "payments/payment_upload_attach" ;
  static  tenantLeases(tenantId) => "leases/$tenantId" ;
  static const PAYMENT_METHOD = "payment_methods?list=payment_method_name,payment_method_display_name" ;
  static const UNIT_TYPES = "unit_types?list=unit_type_name,unit_type_display_name" ;
  static profileEditing(userId) => "landlord_profile/$userId";
  static singleInvoice(userId , invoiceId) => "landlords/$userId/invoices/$invoiceId";
  static leases(userId) => "landlords/$userId/leases";
  static vacateNotes(userId) => "landlords/$userId/notices?";
  static const ADD_UNIT = "units";
  static const LEASE_SUPPORT_DATA = "lease_support_data";
  static const ADD_LEASES = "leases";
  static  editLease (leaseId)=> "leases_update/$leaseId";
  static const ADD_TENANT = "tenants";
  static const ADD_PROPERTY = "properties";
  static editTenant (String tenantId)=> "edit_tenant/$tenantId";
  static const TENANT_TYPES = "tenant_types";
  static MORE_TENANTS (userId)=> "landlords/$userId/tenants";
  static tenantDetailsPayments(tenantId) => "tenants/$tenantId/payments";
  static tenantDetailsLeases(tenantId) => "tenants/$tenantId/leases";
  static const PROPERT_SUPPORT_DATA= "property_support_data";
  static const ADD_WAIVE = "waivers";
 }