import ballerina/http;
import ballerina/io;

public function main() returns error? {
    http:Client httpClient = check new("http://localhost:9090");

    // Adding a new department
    string addDepartmentQuery = "{\"query\":\"mutation { addDepartment(dept: {id: 1, name: 'Computer Science'}) {id, name} }\"}";
    http:Response addDepartmentResponse = check httpClient->post("/performance", addDepartmentQuery, headers = {"Content-Type": "application/json"});
    handleResponse(addDepartmentResponse);

    // Adding a new user to the department
    string addUserQuery = "{\"query\":\"mutation { addUser(departmentId: 1, user: {id: 1, firstName: 'John', lastName: 'Doe', jobTitle: 'Lecturer', position: 'Senior', role: 'Employee'}) {id, firstName, lastName} }\"}";
    http:Response addUserResponse = check httpClient->post("/performance", addUserQuery, headers = {"Content-Type": "application/json"});
    handleResponse(addUserResponse);

    // Adding a new KPI to the user
    string addKpiQuery = "{\"query\":\"mutation { addKPI(userId: 1, kpi: {id: 1, name: 'Teaching Quality', measureUnit: 'Score', targetValue: 5}) {id, name, targetValue} }\"}";
    http:Response addKpiResponse = check httpClient->post("/performance", addKpiQuery, headers = {"Content-Type": "application/json"});
    handleResponse(addKpiResponse);

    // Fetching all departments
    string getDepartmentsQuery = "{\"query\":\"{ departments { id, name } }\"}";
    http:Response getDepartmentsResponse = check httpClient->post("/performance", getDepartmentsQuery, headers = {"Content-Type": "application/json"});
    handleResponse(getDepartmentsResponse);

    // Fetching a specific department
    string getDepartmentQuery = "{\"query\":\"{ department(id: 1) { id, name } }\"}";
    http:Response getDepartmentResponse = check httpClient->post("/performance", getDepartmentQuery, headers = {"Content-Type": "application/json"});
    handleResponse(getDepartmentResponse);
}

function handleResponse(http:Response response) {
    var payload = response.getJsonPayload();
    if (payload is json) {
        io:println("Response: ", payload.toJsonString());
    } else if (payload is error) {
        io:println("Error when calling the backend: ", payload.message());
    }
}
