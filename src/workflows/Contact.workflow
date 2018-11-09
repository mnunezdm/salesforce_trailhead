<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Reset_Birthday</fullName>
        <description>Checks the Schedule Birthday Update field (which will trigger the automatic process to update the Age and Next Birthday fields)</description>
        <field>Schedule_Birthday_Update__c</field>
        <literalValue>1</literalValue>
        <name>Check Reset Birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Reset_Birthday</fullName>
        <description>Unchecks the Schedule Birthday Update, in order to enabling the triggering of the workflow that schedules the automatic update</description>
        <field>Schedule_Birthday_Update__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Reset Birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Age</fullName>
        <description>Updates the age of the Age field based on the birthdate field</description>
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
    <fieldUpdates>
        <fullName>Update_Next_Birthday</fullName>
        <description>Updates the next birthday, based on the birthdate field</description>
        <field>Next_Birthday__c</field>
        <formula>IF(DATE(YEAR(TODAY()),MONTH(Birthdate),DAY(Birthdate)) &lt;= TODAY(),
			DATE(YEAR(TODAY())+1,MONTH(Birthdate),DAY(Birthdate)),
			DATE(YEAR(TODAY()),MONTH(Birthdate),DAY(Birthdate)))</formula>
        <name>Update Next Birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Birthdate Change</fullName>
        <actions>
            <name>Check_Reset_Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Age</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Detects a birthdate change, updates the age and the new birthday. Also will trigger the automatic scheduling of the age field. If there is already an scheduling activated, it gets updates (As it is linked to the Next_Birthday field).</description>
        <formula>OR(
				AND(NOT(ISNULL(Birthdate)),
								ISNULL(Next_Birthday__c)
						 ),
				MONTH(Birthdate) != MONTH(Next_Birthday__c),
				DAY(Birthdate) != DAY(Next_Birthday__c),
				YEAR(PRIORVALUE(Birthdate)) != YEAR(Birthdate) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Schedule Reset Birthday</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Schedule_Birthday_Update__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will be triggered after an update of the birthdate, and will check the schedule field in a time base action, which wll trigger the update next birthdate/age rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Check_Reset_Birthday</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Age and Birthday</fullName>
        <actions>
            <name>Update_Age</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Schedule_Birthday_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This Workflow Rule, will update the birthday and schedule an automatic at the birthday date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Age</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Next_Birthday</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
