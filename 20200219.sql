--���� ���� ��� 11��
--����¡ ó�� (�������� 10���� �Խñ�)
--1������ 1~10
--2����¡ 11~20
--���κ��� :page, :pagesize
--�߿��� �����̴�.
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) gn
        FROM board_test
        START WITH parent_seq is null
        CONNECT BY prior seq = parent_seq
        ORDER SIBLINGS BY gn desc, seq asc) a 
    )
WHERE rn between (:page-1)*:pageSize+1 AND :page*:pageSize;


SELECT part_b.deptno, part_b.ename,part_a.lv
FROM
(SELECT part1.* , rownum a
FROM
(SELECT a.*
FROM
(SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= 14)) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b

WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) part1) part_a, 


(SELECT deptno, ename, rownum a
FROM
(select *
FROM emp e
order by deptno, sal desc, ename)) part_b
WHERE part_a.a = part_b.a;

--���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�

SELECT ename, sal, deptno, ROW_NUMBER() over(partition by deptno order by sal desc) rank
FROM emp;

--�м��Լ� ����
--�л��Լ���([����]) over([partition by �÷�] [order by �÷�] [windowing]);
--PARTITION BY �÷� : �ش��÷��� ���� ROW���� �ϳ��� �׷����� ���´�.
--ORDER BY �÷� : PARTITION BY�� ���� ���� �׷� ������ ORDER BY �÷����� �����ϰڴ�.

ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank;

--���� ���� �м��Լ�
--RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
--         2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.
--DENS_RANK() : ���� ���� ������ �ߺ������� ����, �ļ����� �ߺ����� �������� �����Ѵ�.
--              2���� 2���̴��� �ļ����� 3����� ����
--ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� ����
--

�μ���, �޿� ������ 3���� ��Ű ���� �Լ��� ����
SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal desc) rank
        ,DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal desc) dens,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal desc) rn
FROM emp;

--anal : 

SELECT emp.* , ROW_NUMBER() OVER(ORDER BY sal desc) rank
             , RANK() OVER(ORDER BY sal desc , empno) rank
             ,DENSE_RANK() OVER(ORDER BY sal desc, empno) rank
FROM emp;

SELECT a.empno, a.ename, a.deptno, b.c
FROM
    (SELECT *
    FROM emp) a
    
    JOIN
    
    (SELECT deptno, count(*) c
    FROM emp 
    GROUP BY deptno)b
    
    ON(a.deptno = b.deptno)
ORDER BY a.deptno;


--������ �м��Լ�(GROUP �Լ����� �����ϴ� �Լ� ����� ����)
--SUM(�÷�)
--COUNT(*), COUNT(�÷�)
--MIN(�÷�)
--MAX(�÷�)
--AVG(�÷�)

--no_ana2�� �м��Լ��� ����Ͽ� �ۼ�
--�μ��� ������

SELECT empno, ename, deptno, COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

SELECT empno,ename, deptno, ROUND(AVG(sal) OVER(PARTITION BY deptno),2) avg
FROM emp;

SELECT empno,ename, deptno, MAX(sal) OVER(PARTITION BY deptno) MAX
FROM emp;

SELECT empno, ename, deptno, MIN(sal) OVER(PARTITION BY deptno) MIN
FROM emp;

�޿��� �������� �����ϰ�, �޿��� ���� �� �Ի����ڰ� ��������� ���� �켱������ �ǵ��� �����Ͽ�
�������� ������(lead)�� sal �÷��� ���ϴ� ���� �ۼ�

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal desc,hiredate) lead_sal
FROM emp;

SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal desc, hiredate) lad_sas
FROM emp;


SELECT empno, ename, hiredate, job, sal, Lag(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) a
FROM emp;

SELECT empno, ename, sal, sum(LAG(sal) OVER(ORDER BY sal asc)+ sal)
FROM(
SELECT empno, ename, sal, 0 as a
FROM emp)
GROUP BY empno, ename, sal;

no_ana3�� �м��Լ��� �̿��Ͽ� SQL �ۼ�

SELECT empno, ename, sal, sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

�������� �������� ������ ����� ���� ������� �� 3������ sal �հ� ���ϱ�
SELECT empno, ename, sal, sum(sal) OVER( ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;


SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ORDER BY ����� WINDOWING ���� ������� ���� ��� ���� WINDOWING�� �⺻ ������ ����ȴ�.
--RANGE UNBOUNDED PRECEDING
--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--�ΰ��� �������̴�

SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno RANGE UNBOUNDED PRECEDING) c_sum
FROM emp;

SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
sum(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING) range_,
sum(sal) OVER(PARTITION BY deptno ORDER BY sal ) default_
FROM emp;

--row�� ����
--range�� �ߺ����� �����ؼ����Ѵ�.
--default�� range�� ����.
--WINDOWING�� RANGE, ROWS��
--RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���
--ROWS : �������� ���� ����
