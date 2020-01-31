--DATE : TO_DATE ���ڿ� -> ��¥ (DATE)
--       TO_CHAR ��¥ -> ���ڿ�(��¥ ���� ����)
-- JAVA������ ��¥ ������ ��ҹ��ڸ� ������. (MM  / mm -> ��, ��)
-- D �ְ����� -> �ְ�����(1~7) : �Ͽ���1, ������2 .... ����� 7
-- ���� IW : ISOǥ�� - �ش����� ������� �������� ������ ����
--           2019/12/31 ȭ���� --> 2020/01/02(�����) --> �׷��� ������ 1������ ����




SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS'),
        TO_CHAR(SYSDATE, 'D'), --������ 2020/01/29 (��) --> 4
        TO_CHAR(SYSDATE, 'IW'),
        TO_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'),'IW')
FROM dual;


--emp ���̺��� hiredate(�Ի�����) �÷��� ����� �� :��:��

SELECT ename, hiredate, 
       TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),
       TO_CHAR(hiredate+1, 'YYYY-MM-DD HH24:MI:SS'),--�Ϸ�
       TO_CHAR(hiredate+1/24, 'YYYY-MM-DD HH24:MI:SS'),--�ѽð�
       TO_CHAR(hiredate+(1/24/60)*30, 'YYYY-MM-DD HH24:MI:SS')--��
FROM emp;
-- 30���� ���ϴ� ���� 1/24/2 �� �ְ� (1/24/60)*30�� �ִµ� ���ڰ� �ξ� �������� ���� 


SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') DT_dast_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY')dt_dd_mm_yyyy
FROM DUAL;

SELECT MONTHS_BETWEEN(TO_DATE('2020-08-15','YYYY-MM-DD'),SYSDATE )
FROM dual;

--MONTHS BETWEEN(DATE, DATE) �����ڿ��� �����ڸ� ��
--���ڷ� ���� �� ��¥ ������ �������� ����
SELECT ename, hiredate,
        MONTHS_BETWEEN(sysdate, hiredate),
        MONTHS_BETWEEN(TO_DATE('2020-01-17', 'YYYY-MM-DD'),hiredate),
        469/12
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE, ����-������ ������)
SELECT ADD_MONTHS(SYSDATE,5),  --2020-01-29 -->2020-06-29
        ADD_MONTHS(SYSDATE, -5)
FROM dual;

--NEXT_DAY(DATE, �ְ�����), ex: NEXT_DAY(SYSDATE, 5) --> SYSDATE���� ó�� �����ϴ� �ְ����� 5�� �ش��ϴ� ����
--                              SYSDATE 2020/0129(��) ���� ó�� �����ϴ� 5(��)���� --> 2020/01/30(��)

SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE�� ���� ���� ������ ���ڸ� ����
SELECT LAST_DAY(SYSDATE) --SYSDATE 2020/01/29 --> 2020/01/31
FROM dual;

--LAST_DAY�� ���� ���ڷ� ���� date�� ���� ���� ������ ���ڸ� ���Ҽ� �ִµ�
--date�� ù��° ���ڴ� ��� ���ұ�?

SELECT SYSDATE,
        LAST_DAY(SYSDATE),
        ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),
        TO_DATE('01','DD'), -- �Է´����� ���� ��¥�� �� 
        TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM dual;

--hiredate ���� �̿��Ͽ� �ش���� ù��° ���ڷ� ǥ��
SELECT ename, ADD_MONTHS(LAST_DAY(hiredate)+1,-1) as day
FROM emp;


-- empno�� NUMBERŸ��, ���ڴ� ���ڿ� -> Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ��.
-- ���̺� �÷��� Ÿ�Կ� �°� �ùٸ� ���� ���� �ִ°� �߿��ϴ�.
-- ������ �� ��ȯ empno�� number(4)�ε� '7369'�� ���ڿ� �ڵ������� ����ȯ�� �̷������.
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM emp
WHERE empno = 7369;

--hiredate�� ��� DATE Ÿ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�
--��¥ ���ڿ����� ��¥ Ÿ������ ��������� ����ϴ� ���� ����

SELECT *
FROM emp
WHERE hiredate ='1980/12/17';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM table(dbms_xplan.display);

Plan hash value: 3956160932
 
 --�����ȹ�� �д¹��
--������ �Ʒ��� ������ �鿩���Ⱑ �Ȱ��� �ڽ��̹Ƿ� �ڽĸ��� �����ڿ� �θ� �д´�.
--TABLE ACCESS FULL -> �� �д´�
    --------------------------------------------------------------------------
    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    --------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
    |*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
    --------------------------------------------------------------------------
     
    Predicate Information (identified by operation id):
    ---------------------------------------------------
     
       1 - filter("EMPNO"=7369)  -- �ڵ������� ����ȯ�� �̷������.
     
    Note
    -----
       - dynamic sampling used for this statement (level=2)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

    Plan hash value: 3956160932
     
    --------------------------------------------------------------------------
    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    --------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
    |*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
    --------------------------------------------------------------------------
     
    Predicate Information (identified by operation id):
    ---------------------------------------------------
     
       1 - filter(TO_CHAR("EMPNO")='7369') --������ ���ڿ��� �������Ƿ� �����ʵ� ����ȯ�� ���� �ʾҴ�.
     
    Note
    -----
       - dynamic sampling used for this statement (level=2)
   

--���ڸ� ���ڿ��� �����ϴ� ��� : ����
--õ���� ������
-- 1000�̶�� ���ڸ�
-- �ѱ� : 1,000.50
-- ���� : 1.000,50

-- emp sal �÷�(NUMBER Ÿ��)�� ������
-- 9 : ����
-- 0 : ���� �ڸ� ����(0���� ǥ��)
-- L : ��ȭ����
SELECT ename, sal, TO_CHAR(sal, 'L0,999')
FROm emp;

--NULL�� ���� ������ ����� �׻� NULL
-- emp ���̺��� sal �÷����� null �����Ͱ� ���� ���� ����
-- emp ���̺��� comm �÷����� null�����Ͱ� ���� (14���� �����Ϳ� ����)
-- sal + comm --> comm�� null�� �࿡ ���ؼ��� ��� null�� ���´�.
-- �䱸������ comm�� null�̸� sal �÷��� ���� ��ȸ�ǵ���
-- �䱸������ ���� ��Ű�� ���Ѵ�.

-- NVL(Ÿ��, ��ü��)
-- Ÿ���� ���� NULL�̸� ��ü���� ��ȯ
-- Ÿ���� ���� NULL�� �ƴϸ� Ÿ�� ���� ��ȯ
--  if(Ÿ�� == null)
--      return ��ü��;
--  else
--      return Ÿ��;
SELECT ename, sal, comm, sal +comm
FROM emp;

SELECT ename, sal, comm,NVL(comm,0), 
        sal+NVL(comm, 0),
        NVL(sal+comm, 0) -- 
FROM emp;

--NVL2(expr1, expr2, expr3)
--if(expr != null)
--      return expr2
--else
--      return expr3;

SELECT ename, sal, comm, NVL2(comm, 10000, 0)
FROM emp;

--NULLIF(expr1, expr2)
-- if(expr1 == expr2)
--      return null;
-- else
--      return expr1;
--sal 1250�� ����� null�� ����, 1250�� �ƴ� ����� sal�� ����
SELECT ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--��������
--COALESCE �����߿� ���� ó������ �����ϴ� NULL�� �ƴ� ���ڸ� ��ȯ
--COALESCE(expr1, expr2...)
--if(expr1 != null)
--  return expr1
--else
--  return COALESCE(expr2, expr3.....)

--COALESCE(comm,sal) : comm�� null�� �ƴϸ� comm
                    -- comm�� null �̸� sal(��, sal �÷��� ���� NULL�� �ƴҶ�)
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- null �ǽ� fn4
SELECT empno, ename, MGR, NVL(MGR,9999) MGR_N, NVL2(MGR,MGR,9999) MGR_N_1, COALESCE(MGR,NVL(MGR,9999),NVL2(MGR,MGR,9999)) MGR_N
FROM emp;

-- null �ǽ� fn5
SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) n_reg_dt
FROM users
WHERE userid != 'brown';
--where userid in('cony','sally','james','moon');


--CONDITION : ������
--CASE : JAVA�� if -else if -else ���� ����ϴ�.
--CASE
--      WHEN ����1 THEN ���ϰ�1
--      WHEN ����2 THEN ���ϰ�2
--      ELSE �⺻��
--END
--emp ���̺��� job �÷��� ���� SALESMAN SAL * 1.05 ����
--                               MANAGER �̸� SAL * 1.1 ����
--                               PRESIDENT �̸� SAL * 1.2 ����
--                               �� �ۿ� ������� SAL�� ����

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus_sal
        
FROM emp;



--DECODE �Լ� : CASE ���� ����
--(�ٸ��� CASE �� : WHEN ���� ���Ǻ񱳰� �����Ӵ�
--        DECODE �Լ� : �ϳ��� ���� ���ؼ� = �񱳸� ���
--DECODE �Լ� : ��������(������ ������ ��Ȳ�� ���� �þ ���� ����)
--DECODE(col|expr, ù��° ���ڿ� ���Ұ�1, ù��° ���ڿ� �ι�° ���ڰ� ������� ��ȯ ��
--                  ù���� ���ڿ� ���Ұ�2, ù��° ���ڿ� �׹�° ���ڰ� ������� ��ȯ�� ..
--                  option -else ���������� ��ȯ�� �⺻��)

--emp ���̺��� job �÷��� ���� SALESMAN�̸鼭 sal�� 1400���� ũ�� SAL * 1.05 ����
--                               SALESMAN�̸鼭 sal�� 1400���� ������ SAL * 1.1 ����
--                               MANAGER �̸� SAL * 1.1 ����
--                               PRESIDENT �̸� SAL * 1.2 ����
--                               �� �ۿ� ������� SAL�� ����


SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', sal * 1.05,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal * 1.2,
                    sal) bonus_sal
FROM emp;


--1. CASE

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' AND sal>1400 THEN sal * 1.05
            WHEN job = 'SALESMAN' AND sal<1400 THEN sal * 1.1
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal 
        END bonus_sal
FROM emp;

--2.DECODE
SELECT ename, job, sal,
        DECODE(
            job , 'SALESMAN' , case
                                WHEN sal>1400 THEN sal*1.05
                                ELSE sal *1.1
                               end,                              
                'MANAGER', sal*1.1,
                'PRESIDENT', sal*1.2,
                sal) bonus_sal
FROM emp;
                                
            