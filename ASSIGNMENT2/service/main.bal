import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "perfomanceDB"
};
mongodb:Client db = check new (mongoConfig);


service /performance on new graphql:Listener(9090) {
    private Department[] departments = [];

    resource function get departments() returns Department[] {
        return self.departments;
    }
    
    
    resource function get department(int id) returns Department|graphql:Error {
        foreach Department department in self.departments {
            if (department.id == id) {
                return department;
            }
        }
        return graphql:Error("Department not found");
    }

    resource function post addDepartment(DepartmentInput dept) returns Department {
        Department department = {
            id: dept.id,
            name: dept.name,
            objectives: [],
            users: []
        };
        self.departments.push(department);
        return department;
    }

    resource function post addUser(int departmentId, UserInput user) returns User|graphql:Error {
        foreach Department department in self.departments {
            if (department.id == departmentId) {
                User newUser = {
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    jobTitle: user.jobTitle,
                    position: user.position,
                    role: user.role,
                    kpis: []
                };
                department.users.push(newUser);
                return newUser;
            }
        }
        return graphql:Error("Department not found");
    }

    resource function post addKPI(int userId, KPIInput kpi) returns KPI|graphql:Error {
        foreach Department department in self.departments {
            foreach User user in department.users {
                if (user.id == userId) {
                    KPI newKPI = {
                        id: kpi.id,
                        name: kpi.name,
                        measureUnit: kpi.measureUnit,
                        targetValue: kpi.targetValue,
                        actualValue: 0
                    };
                    user.kpis.push(newKPI);
                    return newKPI;
                }
            }
        }
        return error ("User not found";
    }
}

public type Department record {
    int id;
    string name;
    Objective[] objectives;
    User[] users;
};

public type Objective record {
    int id;
    string name;
    int weight;
};

public type User record {
    int id;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    string role;
    KPI[] kpis;
};

public type KPI record {
    int id;
    string name;
    string measureUnit;
    int targetValue;
    int actualValue;
};

public type DepartmentInput record {
    int id;
    string name;
};

public type UserInput record {
    int id;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    string role;
};

public type KPIInput record {
    int id;
    string name;
    string measureUnit;
    int targetValue;
};
