SELECT ename, job, sal, 
        DECODE(job, 'SALESMAN', CASE
                                    WHEN sal > 1400 THEN sal * 10.5
                                    WHEN sal < 1400 THEN sal * 1.1
                                END,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal*1.2,
                    sal) bonus_sal
FROM emp;

--cond1
--case
SELECT empno, ename, CASE
                        WHEN deptno=10 THEN 'ACCOUNTING'
                        WHEN deptno=20 THEN 'RESEARCH'
                        WHEN deptno=30 THEN 'SALES'
                        WHEN deptno=40 THEN 'OPERATIONS'
                        ELSE 'DDIT'
                    END dname
FROM emp;
--decode
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING'
                                 , 20, 'RESEARCH'
                                 , 30, 'SALES'
                                 ,40, 'OPERATIONS'
                                 ,'DDIT') dname
FROM emp;


--cond3
SELECT empno, ename, hiredate,
                            CASE
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2)=0 THEN
                                    (CASE WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)=0 THEN '�ǰ����������'
                                        WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)!=0 THEN '�ǰ�����������'
                                     END)
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2)!=0 THEN
                                    (CASE WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)!=0 THEN '�ǰ����������'
                                        WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)=0 THEN '�ǰ�����������'
                                     END)
                             END CONTACT_TO_DOCTOR
FROM emp;


SELECT empno, ename, hiredate,
                            CASE
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
                                THEN '�ǰ����������'
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
                                THEN '�ǰ�����������'
                            END CONTACT_TO_DOCTOR                                                              
FROM emp;


SELECT empno, ename, hiredate, DECODE(
                                MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) , 
                                MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2),
                                '�ǰ����������',
                                '�ǰ�����������')

                                �ǰ�
FROM emp;


-- GROUP BY ���� ���� ����
-- �μ���ȣ ���� ROW���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW���� ���� ��� : GROUP BY mgr, job

--�׷��Լ��� ����
-- sum : �հ�
-- count : ���� --> NULL�� �ƴ� ROW�� ���� (NULL�� �����Ѵ�.)
-- MAX : �ִ밪
-- MIN : �ּҰ�
-- AVG : ���

--�׷��Լ��� Ư¡
--�ش� �÷���NULL���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����Ѵ�.(NULL ������ ����� NULL)

--�μ��� �޿� ��

--�׷��Լ� ������
--GROUP BY ���� ���� �÷��̿��� �ٸ� �÷��� SELECT���� ǥ���Ǹ� ����
SELECT deptno, ename,
        SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno)
FROM emp
GROUP BY deptno ,ename;


--GROUPY BY ���� ���� ���¿��� �׷��Լ��� ��� �� ���
--GROUP BY�� ���ٸ� ��ü���� �ϳ��� ������ ���´ٴ� ��

SELECT --deptno, ename, -> �ٽ� �����غ���
        SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno),
        COUNT(sal), --sal Į���� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) --����� �����Ͱ� �ִ���
FROM emp;

SELECT *
FROM emp;

--GROUP BY�� ������ empno�̸� ������� ���?
-- 1 sysdate accounting ���� �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���ڵ��� SELECT�� ������ ���� �����ϴ�. 
SELECT  1,SYSDATE,'ACCOUNTING',SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno),
        COUNT(sal), --sal Į���� ���� null�� �ƴ� row�� ����
        COUNT(comm), -- COMM �÷��� ���� null�� �ƴ� row�� ����
        COUNT(*) --����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;

--SINGLE ROW FUNCTION�� ��� WHERE������ ����ϴ� ���� �����ϳ�
--MULTI ROW FUNCTION(GROUP FUNCTION)�� ��� WHERE������ ����ϴ� ���� �Ұ��� �ϰ�
--HAVING ������ ������ ����Ѵ�.

--�μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻���  row�� ��ȸ
--deptno, �޿���

SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno
HAVING sum(sal)>=9000;

--grp1

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp;


--grp2

SELECT deptno,MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY deptno;

--grp3

SELECT DECODE( deptno, 10, 'ACCOUNTING', 20, 'RESEARCH',30,'SALES' ) DEPTNO 
,MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY DECODE( deptno, 10, 'ACCOUNTING', 20, 'RESEARCH',30,'SALES' );

--grp4 --> �ѹ��� Ȯ��
-- ORACLE 9i ���������� GROUP BY���� ����� �÷����� ������ ����
-- ORACLE 10g ���� ���ʹ� GROUP BY ���� ����� �÷����� ������ �������� �ʴ´�.(GROUP BY ����� �ӵ� UP)

SELECT TO_CHAR(hiredate,'YYYYMM') hiredate_YYYYMM, count(*)
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

--grp5
SELECT TO_CHAR(hiredate, 'YYYY') hre_YYYY, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


