<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Reset_Birthday_Email_System_Box</fullName>
        <field>Reset_Birthday_Email_System__c</field>
        <literalValue>1</literalValue>
        <name>Check Reset Birthday Email System Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Birthday_Email</fullName>
        <field>Reset_Birthday_Email_System__c</field>
        <literalValue>0</literalValue>
        <name>Reset Birthday Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Next_Birthday</fullName>
        <field>Next_Birthday__c</field>
        <formula>IF(DATE(YEAR(TODAY()),MONTH(Birthdate),DAY(Birthdate)) &lt;= TODAY(),
			DATE(YEAR(TODAY())+1,MONTH(Birthdate),DAY(Birthdate)),
			DATE(YEAR(TODAY()),MONTH(Birthdate),DAY(Birthdate)))</formula>
        <name>Reset Next Birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Age</fullName>
        <field>Age__c</field>
        <formula>YEAR(TODAY()) -  YEAR(Birthdate) -
    IF(MONTH(TODAY()) &lt; MONTH(Birthdate),
							1,
							IF(MONTH(TODAY()) &gt; MONTH(Birthdate),
										0,
										IF(DAY(TODAY()) &lt; DAY(Birthdate),
													1,
													0
												)
									)
						)</formula>
        <name>Update Age</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Birthday Change</fullName>
        <actions>
            <name>Check_Reset_Birthday_Email_System_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Age</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
				AND(NOT(ISNULL(Birthdate)),
								ISNULL(Next_Birthday__c)
							),
				MONTH(Birthdate) != MONTH(Next_Birthday__c),
				DAY(Birthdate) != DAY(Next_Birthday__c),
				ISCHANGED(Birthdate)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset Birthday Email</fullName>
        <actions>
            <name>Reset_Next_Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Age</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Birthday_Email_System__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reset_Birthday_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Age</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Birthday_Email_System__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Age</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Check_Reset_Birthday_Email_System_Box</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
