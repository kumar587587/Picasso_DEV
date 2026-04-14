create or replace FUNCTION "XX2SPM_HASH_VALUE" ( p_table_name IN VARCHAR2 )
   RETURN raw
   IS
      c_routine_name        CONSTANT VARCHAR2(30) := 'hash_value';          
      l_stm                 VARCHAR2(32000);
      l_concatenated_values XX2SPM_ARRAY_VARCHAR_TYPE;
      l_clob                CLOB;
      l_raw                 RAW(32000);  
   FUNCTION bubbel_sort ( p_input_array    in  XX2SPM_ARRAY_VARCHAR_TYPE)
   RETURN XX2SPM_ARRAY_VARCHAR_TYPE
   IS
      c_routine_name   CONSTANT VARCHAR2(30)       := 'bubbel_sort';          
      l_sorted_array   XX2SPM_ARRAY_VARCHAR_TYPE     := p_input_array;
      l_swapped        BOOLEAN; 
      l_values         VARCHAR2(6000);
   BEGIN
      --debug( c_routine_name, '(start)' );  
      --debug( c_routine_name, 'parameter_1 = '||parameter_1 );  
      LOOP
         l_swapped := false;
         --  
         --debug( c_routine_name,  'bubbel sort  l_sorted_values.count = '||p_input_array.count );
         FOR i IN 2 .. l_sorted_array.count LOOP
             --debug( c_routine_name,  'i = '||i );
             IF l_sorted_array(i-1) > l_sorted_array(i) THEN
                --debug( c_routine_name,  'swapping' );
                -- swap records
                l_values := l_sorted_array(i);
                -- 
                l_sorted_array(i) := l_sorted_array(i-1);
                l_sorted_array(i-1) := l_values;
                /*
                Mark that swap has taken place. note we mark as true only inside
                the if block, meaning a swap really did take place
                */
                l_swapped := true;
             END IF;
         END LOOP; 
         --debug( c_routine_name,  'swapping end' );
         -- If we passed through table without swapping we are done, so exit
         EXIT WHEN NOT l_swapped;
      END LOOP;
      --
      --debug( c_routine_name, '(end)'); 
      --
      RETURN l_sorted_array;
      --
   END bubbel_sort;        
   BEGIN
      --debug( c_routine_name, '(start)' );  
      --debug( c_routine_name, 'p_table_name = '||p_table_name );  
      --
      l_stm  := 'select concatenated_values from '||p_table_name; -- ||' order by '||p_order_by;
      --debug( c_routine_name, 'l_stm = '||l_stm );  
      --
      EXECUTE IMMEDIATE l_stm BULK COLLECT INTO l_concatenated_values;

      l_concatenated_values := bubbel_sort ( l_concatenated_values );
      --
      FOR idx IN 1..l_concatenated_values.count  LOOP
          --debug( c_routine_name, 'idx = '||idx );  
          --debug( c_routine_name, 'l_concatenated_values(idx) = '||l_concatenated_values(idx) );
          --if substr(l_concatenated_values(idx),1,3) = '["X' then
             l_clob := l_clob||l_concatenated_values(idx)||chr(13);
          --end if;
      END LOOP;
      --
      xxpm_gen_debug_pkg.debug_cs( c_routine_name, 'ODIS '||p_table_name||' file contents' ,l_clob );  
      --
      IF l_clob IS NOT NULL THEN
         l_raw := DBMS_CRYPTO.Hash ( l_clob ,dbms_crypto.HASH_MD5);
      END IF;   
      --
      --debug( c_routine_name, '(end) l_raw = '||l_raw);      
      RETURN l_raw;
      --
   EXCEPTION
   WHEN OTHERS THEN
      --xxice_debug_pkg.debug( c_routine_name, 'ERROR: '||sqlerrm);      
      RAISE;
   END xx2spm_hash_value;