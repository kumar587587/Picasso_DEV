--------------------------------------------------------
--  DDL for Trigger XXCPC_CONTRACTBILLINGINF_AIUD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTBILLINGINF_AIUD" 
  AFTER INSERT OR DELETE OR UPDATE ON "WKSP_XXCPC"."XXCPC_CONTRACTBILLINGINF"
  REFERENCING FOR EACH ROW
  DECLARE
    c_trigger_name         CONSTANT VARCHAR2(50):= 'XXCPC_CONTRACTBILLINGINF_AIUD';  
    l_new_values_string    VARCHAR2(32000);
    l_old_values_string    VARCHAR2(32000);
    l_api_return_value     VARCHAR2(32000);
    --
    l_pl_table_name        VARCHAR2(50) := 'spContractBillingInformation';
    l_pl_pk_field          VARCHAR2(50) := 'ContractID,StartDate';

    L_CONTRACTNR            VARCHAR2(20);
    L_MEMOLINE_ID           NUMBER;
    L_VATCODE_ID            NUMBER;
    L_VATCODE               VARCHAR2(500);
    L_MEMOLINE              VARCHAR2(500);
BEGIN       
    xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(start)' );
    IF inserting THEN
       xxcpc_gen_rest_apis.insert_date( :new.startdate );
       xxcpc_gen_rest_apis.insert_date( :new.enddate );
    END IF;

    IF updating THEN
		IF :old.startdate <> :new.startdate THEN
			xxcpc_gen_rest_apis.insert_date( :new.startdate );
		END IF;
		IF :old.enddate <> :new.enddate THEN
			xxcpc_gen_rest_apis.insert_date( :new.enddate );
		END IF;
    END IF;

	IF inserting OR updating THEN
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting or updating' );

		SELECT CONTRACTNR INTO L_CONTRACTNR FROM XXCPC_CONTRACTS WHERE ID = :NEW.CONTRACTNUMBERID;

		SELECT MEMOLINEID, VATCODEID INTO L_MEMOLINE_ID,L_VATCODE_ID FROM XXCPC_CONTENTPARTNERBILLINGINF WHERE ID = :NEW.CONTENTPARTNERBILLINGINFID;

		SELECT CODE INTO L_VATCODE FROM XXCPC_LOOKUPS WHERE TYPE = 'VATCODE' AND ID = L_VATCODE_ID;

		SELECT CODE INTO L_MEMOLINE FROM XXCPC_LOOKUPS WHERE TYPE = 'MEMOLINE' AND ID = L_MEMOLINE_ID;

		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'RNS 2 DATA=='||L_CONTRACTNR||'=='||L_MEMOLINE||'=='||L_VATCODE);

		l_new_values_string :=  '"'||upper(L_CONTRACTNR)||'",'||
								'"'||UPPER(L_MEMOLINE)||'",'||
								'"'||UPPER(L_VATCODE)||'",'||
								'"'||UPPER(:NEW.BUSINESS_LINE)||'",'||
								'"'||TO_CHAR(:NEW.STARTDATE,'MM/DD/YYYY')||'",'||
								'"'||TO_CHAR(:NEW.ENDDATE,'MM/DD/YYYY')||'",'||
                                '"'||NULL||'"'||
								'';
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'RNS 3 DATA=='||l_new_values_string );
	END IF;

	IF updating OR deleting THEN
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating or deleting' );

		SELECT CONTRACTNR INTO L_CONTRACTNR FROM XXCPC_CONTRACTS WHERE ID = :OLD.CONTRACTNUMBERID;

		SELECT MEMOLINEID, VATCODEID INTO L_MEMOLINE_ID,L_VATCODE_ID FROM XXCPC_CONTENTPARTNERBILLINGINF WHERE ID = :OLD.CONTENTPARTNERBILLINGINFID;

		SELECT CODE INTO L_VATCODE FROM XXCPC_LOOKUPS WHERE TYPE = 'VATCODE' AND ID = L_VATCODE_ID;

		SELECT CODE INTO L_MEMOLINE FROM XXCPC_LOOKUPS WHERE TYPE = 'MEMOLINE' AND ID = L_MEMOLINE_ID;

		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from spTable' );

		l_old_values_string :=  '"'||upper(L_CONTRACTNR)||'",'||
								'"'||UPPER(L_MEMOLINE)||'",'||
								'"'||UPPER(L_VATCODE)||'",'||
								'"'||UPPER(:OLD.BUSINESS_LINE)||'",'||
								'"'||TO_CHAR(:OLD.STARTDATE,'MM/DD/YYYY')||'",'||
								'"'||TO_CHAR(:OLD.ENDDATE,'MM/DD/YYYY')||'",'||
                                '"'||NULL||'"'||
								'';
	END IF;

	IF inserting THEN
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting' );
       -- IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(L_CONTRACTNR)||TO_CHAR(:NEW.STARTDATE,'MM/DD/YYYY') ),NULL) THEN
        IF NOT xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(L_CONTRACTNR) )||';StartDate='||to_char(:NEW.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00', null ) THEN
            xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting--2 l_new_values_string=='|| l_new_values_string);

			xxcpc_gen_rest_apis.insert_row
				( p_table_name      => l_pl_table_name
				, p_key_values      => l_new_values_string
				, p_new_values      => l_new_values_string
				, p_effective_date  => NULL
				, p_overwrite       => NULL
				);
		END IF;

		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'inserting--3 insert end');
	END IF;

	IF updating THEN  
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'updating' );
		xxcpc_gen_rest_apis.update_row
			( p_table_name     => l_pl_table_name
			, p_key_values     => l_new_values_string
			, p_apex_id        => :new.id
			, p_new_values     => l_new_values_string
			, p_old_values     => l_old_values_string
			, p_old_rowid      => :old.rowid
			, p_effective_date => null
			, p_overwrite      => false
			);
	END IF;

	IF deleting THEN  
		xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting' );
        --IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, l_pl_pk_field||'='||xxcpc_gen_rest_apis.escape(upper(L_CONTRACTNR) ),NULL) THEN
		IF xxcpc_gen_rest_apis.does_row_with_pk_exist( l_pl_table_name, l_pl_pk_field, 'ContractID='||xxcpc_gen_rest_apis.escape(upper(L_CONTRACTNR) )||';StartDate='||to_char(:OLD.startdate,xxcpc_gen_rest_apis.gc_varicent_date_format)||'T00:00:00', null ) THEN
        	xxcpc_gen_rest_apis.delete_row( l_pl_table_name , l_old_values_string, l_old_values_string );
		ELSE
			xxcpc_gen_debug_pkg.debug_t( c_trigger_name, 'deleting from '||l_pl_table_name||' NOT FOUND?????');
		END IF;
	END IF;

	xxcpc_gen_debug_pkg.debug_t( c_trigger_name, '(end)' );

END XXCPC_CONTRACTBILLINGINF_AIUD;

/
ALTER TRIGGER "WKSP_XXCPC"."XXCPC_CONTRACTBILLINGINF_AIUD" ENABLE;
