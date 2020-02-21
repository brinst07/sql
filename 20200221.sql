CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
       
    begin
        
        INSERT INTO dept VALUES(p_deptno,p_dname,p_loc);
        COMMIT;
    END;
/

exec registdept_test (55,'PARK','SEOUL');

select *
from dept;

desc dept;

DELETE FROM dept
WHERE deptno = 55;


CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS


BEGIN


    UPDATE dept SET deptno = p_deptno, dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
END;
/

exec UPDATEdept_test(55, 'ddit_m','daejeon');

select *
from dept;


--���պ��� %rowtype : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ����
--��� ��� : ������ ���̺��%rowtype


DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname || ' ' || v_dept_row.loc);
END;
/


���պ��� RECORD
�����ڰ� ���� �������� �÷��� ������ �� �ִ� Ÿ���� �����ϴ� ���
JAVA�� �����ϸ� Ŭ������ �����ϴ� ����
�ν��Ͻ��� ����� ������ ��������

����
TYPE Ÿ���̸�(�����ڰ� ����) IS RECORD(
        ������1 ����Ÿ��,
        ������2 ����Ÿ��
);

������ Ÿ���̸�  --Ÿ���� �ν��Ͻ�ȭ�ϴ� �����̴�.

DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14)
    );
    
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);

END;
/


--table type ���̺� Ÿ��
--�� : ��Į�� ����
--�� : %ROWTYPE, record type
--�� : table type
--     � ��(%ROWTYPE, RECORD)�� ������ �� �ִ���
--     �ε��� Ÿ���� ��������
     

DEPT ���̺��� ������ ���� �� �ִ� TABLE TYPE�� ����
������ ��� ��Į��Ÿ��, rowtype������ �� ���� ������ ���� �� �־�����
table Ÿ�� ������ �̿��ϸ� �������� ������ ���� �� �ִ�.

PL/SQL ������ �ڹٿ� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� �֤� �ʰ�
���ڿ��� �����ϴ�.

�׷��� TABLE Ÿ���� ������ ���� �ε����� ���� Ÿ�Ե� ���� ���
BINARY_INTEGER Ÿ���� PL/SQL������ ��� ������ Ÿ������
NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰԲ��� NUMBER Ÿ���� ���� Ÿ���̴�.

SET SERVEROUTPUT ON;

DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept_tab dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept_tab
    FROM dept;
    -- ���� ��Į�� ����, record Ÿ���� �ǽ��ÿ���
    -- ���ุ ��ȸ �ǵ��� WHERE ���� ���� �����Ͽ���.
    
    --�ڹٿ����� �迭[�ε��� ��ȣ]
    --table����(�ε��� ��ȣ)�� ����
    FOR i IN 1..v_dept_tab.count LOOP --~~ .count -> length�� ���� ����
    DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno || ' ' || v_dept_tab(i).dname);
    END LOOP;
END;
/


�������� IF
����

IF ���ǹ� THEN
    ���๮;
ELSIF ���ǹ� THEN
    ���๮;
ELSE
    ���๮;
END IF;

DECLARE 
    p NUMBER(1) := 2; --���� ����� ���ÿ� ���� �����Ѵ�.
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�.');
    END IF;
END;
/

CASE ����
1. �Ϲ� ���̽� (JAVA�� switch�� ����)
2. �˻� ���̽� (if, else if , else)

CASE expression
    WHEN value THEN
        ���๮;    
    WHEN value THEN
        ���๮;
    ELSE
        ���๮;
END CASE;

--�Ϲ����̽�
DECLARE
    p NUMBER(1) := 5;
BEGIN
    CASE p 
        WHEN 1 THEN 
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�𸣴� ��');
    END CASE;
END;
/

--�˻����̽� -> ���ݴ� �������� ����̴�. �ֳĸ� ������ �پ��ϰ� ��� �����ϱ⋚����            
DECLARE
    p NUMBER(1) := 5;
BEGIN
    CASE p 
        WHEN p=1 THEN 
            DBMS_OUTPUT.PUT_LINE('1�Դϴ�.');
        WHEN p=2 THEN
            DBMS_OUTPUT.PUT_LINE('2�Դϴ�.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�𸣴� ��');
    END CASE;
END;
/

FOR LOOP ����
FOR ��������/�ε��� ���� IN [REVERSE] ���۰�.. ���ᰪ LOOP
    �ݺ��� ����;
END LOOP;

1���� 5���� FOR LOOP �ݺ����� �̿��Ͽ� �������;

DECLARE
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

DECLARE
BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
        END LOOP;
    END LOOP;
END;
/


WHILE LOOP ����
WHILE ���� LOOP
    �ݺ������� ����
END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP; 
END;    
/

LOOP�� ���� -> while(true)
LOOP
    �ݺ������� ����;
    EXIT ����;
END LOOP;


DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        EXIT WHEN i >5;
        i := i+1;
    END LOOP;    
END;
/

