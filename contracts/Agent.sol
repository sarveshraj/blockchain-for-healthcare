pragma solidity ^0.4.15;

contract Agent {
    
    struct patient {
        string name;
        uint age;
        address[] doctorAccessList;
        uint[] diagnosis;
        string record;
    }
    
    struct doctor {
        string name;
        uint age;
        address[] patientAccessList;
    }

    struct insurer {
        string name;
        uint count_of_patient;
        address[] PatientWhoClaimed;
        address[] DocName;
        uint[] diagnosis; 
    }


    uint creditPool;

    address[] public patientList;
    address[] public doctorList;
    address[] public insurerList;

    mapping (address => patient) patientInfo;
    mapping (address => doctor) doctorInfo;
    mapping (address => insurer) insurerInfo;
    mapping (address => address) Patient_Insurer;
    // might not be necessary
    mapping (address => string) patientRecords;


    function add_agent(string _name, uint _age, uint _designation, string _hash) public {
        address addr = msg.sender;
        
        if(_designation == 0){
            patientInfo[addr].name = _name;
            patientInfo[addr].age = _age;
            patientInfo[addr].record = _hash;
            patientList.push(addr)-1;
        }
       else if (_designation == 1){
            doctorInfo[addr].name = _name;
            doctorInfo[addr].age = _age;
            doctorList.push(addr)-1;

       }
       else if(_designation == 2){
           insurerInfo[addr].name = _name;
           insurerList.push(addr)-1;
       }
       else{
           revert();
       }
    }

    function get_patient(address addr) view public returns (string, uint, uint[], address, string){
        // if(keccak256(patientInfo[addr].name) == keccak256(""))revert();
        return (patientInfo[addr].name, patientInfo[addr].age, patientInfo[addr].diagnosis, Patient_Insurer[addr], patientInfo[addr].record);
    }

    function get_doctor(address addr) view public returns (string, uint){
        // if(keccak256(doctorInfo[addr].name)==keccak256(""))revert();
        return (doctorInfo[addr].name, doctorInfo[addr].age);
    }
    function get_patient_doctor_name(address paddr, address daddr) view public returns (string, string){
        return (patientInfo[paddr].name,doctorInfo[daddr].name);
    }
    function get_insurer(address addr) view public returns (string, uint, address[], address[], uint[] ){
        // if(keccak256(doctorInfo[addr].name)==keccak256(""))revert();
        return (insurerInfo[addr].name, insurerInfo[addr].count_of_patient, insurerInfo[addr].PatientWhoClaimed, 
        insurerInfo[addr].DocName, insurerInfo[addr].diagnosis);
    }

    function permit_access(address addr) payable public {
        require(msg.value == 2 ether);

        creditPool += 2;
        
        doctorInfo[addr].patientAccessList.push(msg.sender)-1;
        patientInfo[msg.sender].doctorAccessList.push(addr)-1;
        

    }

   
    function select_insurer(address iaddr, uint[] _diagnosis) payable public {
        uint total_amount = (_diagnosis.length);
        require(msg.value == total_amount*(1 ether));
        // require(msg.sender.balance >= msg.value);
        iaddr.transfer(msg.value);
        Patient_Insurer[msg.sender] = iaddr;
        patientInfo[msg.sender].diagnosis = _diagnosis;
        insurerInfo[iaddr].count_of_patient++;
    }

    //must be called by doctor
    function insurance_claim(address paddr, uint _diagnosis, string _hash) public {
        bool patientFound = false;
        for(uint i = 0;i<doctorInfo[msg.sender].patientAccessList.length;i++){
            if(doctorInfo[msg.sender].patientAccessList[i]==paddr){
                msg.sender.transfer(2 ether);
                creditPool -= 2;
                patientFound = true;
                
            }
            
        }
        if(patientFound==true){
            set_hash(paddr, _hash);
            remove_patient(paddr, msg.sender);
        }else {
            revert();
        }

        bool DiagnosisFound = false;
        for(uint j = 0; j < patientInfo[paddr].diagnosis.length;j++){
            if(patientInfo[paddr].diagnosis[j] == _diagnosis)DiagnosisFound = true;
        }
        if(DiagnosisFound){
            insurerInfo[Patient_Insurer[paddr]].PatientWhoClaimed.push(paddr)-1;
            insurerInfo[Patient_Insurer[paddr]].DocName.push(msg.sender)-1;
            insurerInfo[Patient_Insurer[paddr]].diagnosis.push(_diagnosis)-1;
        }
    }

    //must be called by insurer

    function accept_claim(address paddr) public payable {
        // require(msg.sender.balance >= msg.value);
        require(msg.value == 4 ether);
        paddr.transfer(msg.value);
        uint index;
        remove_element_in_array(insurerInfo[msg.sender].PatientWhoClaimed,paddr);
        if(insurerInfo[msg.sender].diagnosis.length == 1){
            delete insurerInfo[msg.sender].DocName[index];
        }
        else {
            insurerInfo[msg.sender].DocName[index] = insurerInfo[msg.sender].DocName[insurerInfo[msg.sender].DocName.length - 1];
            delete insurerInfo[msg.sender].DocName[insurerInfo[msg.sender].DocName.length - 1];

        }
        insurerInfo[msg.sender].DocName.length--;

        if(insurerInfo[msg.sender].diagnosis.length == 1){
            delete insurerInfo[msg.sender].diagnosis[index];
        }
        else {
            insurerInfo[msg.sender].diagnosis[index] = insurerInfo[msg.sender].diagnosis[insurerInfo[msg.sender].diagnosis.length - 1];
            delete insurerInfo[msg.sender].diagnosis[insurerInfo[msg.sender].diagnosis.length - 1];

        }
        insurerInfo[msg.sender].diagnosis.length--;   
    }
    
    function remove_element_in_array(address[] storage Array, address addr) internal returns(uint)
    {
        bool check = false;
        uint del_index = 0;
        for(uint i = 0; i<Array.length; i++){
            if(Array[i] == addr){
                check = true;
                del_index = i;
            }
        }
        if(!check) revert();
        else{
            if(Array.length == 1){
                delete Array[del_index];
            }
            else {
                Array[del_index] = Array[Array.length - 1];
                delete Array[Array.length - 1];

            }
            Array.length--;
        }
    }

    function remove_patient(address paddr, address daddr) public {
        remove_element_in_array(doctorInfo[daddr].patientAccessList, paddr);
        remove_element_in_array(patientInfo[paddr].doctorAccessList, daddr);
    }
    
    function get_accessed_doctorlist_for_patient(address addr) public view returns (address[])
    { 
        address[] storage doctoraddr = patientInfo[addr].doctorAccessList;
        return doctoraddr;
    }
    function get_accessed_patientlist_for_doctor(address addr) public view returns (address[])
    {
        return doctorInfo[addr].patientAccessList;
    }

    
    function revoke_access(address daddr) public payable{
        remove_patient(msg.sender,daddr);
        msg.sender.transfer(2 ether);
        creditPool -= 2;
    }

    function get_patient_list() public view returns(address[]){
        return patientList;
    }

    function get_doctor_list() public view returns(address[]){
        return doctorList;
    }
    function get_insurer_list() public view returns(address[]){
        return insurerList;
    }

    function get_hash(address paddr) public view returns(string){
        return patientInfo[paddr].record;
    }

    function set_hash(address paddr, string _hash) internal {
        patientInfo[paddr].record = _hash;
    }

}

