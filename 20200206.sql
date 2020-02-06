SELECT sido, count(*)
FROM fastfood
WHERE sido LIKE '%����%'
GROUP BY sido;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2,2) hambuger_score
FROM
(SELECT sido, sigungu, count(*) c1
FROM fastfood
WHERE GB IN('KFC','����ŷ','�Ƶ�����')
GROUP BY sido, sigungu) a,

(SELECT sido, sigungu, count(*) c2
FROM fastfood
WHERE GB IN('�Ե�����')
GROUP BY sido, sigungu) b

WHERE a.sido = b.sido AND
a.sigungu = b.sigungu
ORDER BY hambuger_score DESC;


--�������� ����� �ڵ�
--fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
--�Ʒ��� ���� �ڵ带 �ۼ��Ҷ� �и� �Ǵ� �Ե����ư� 0 �ϰ�찡 ����� �̶��� ������ ó���ϴ°� �ƴ϶�
--����ڿ��� ����� �ϴ°��� ����.


SELECT sido, sigungu, ROUND((kfc+����ŷ+mac)/�Ե�����,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '����ŷ', 1)),0)����ŷ,
            NVL(SUM(DECODE(gb, '�Ƶ�����', 1)),0) mac, NVL(SUM(DECODE(gb, '�Ե�����', 1)),1)�Ե�����
        FROM fastfood
        WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
        GROUP BY sido, sigungu)
ORDER BY score desc;

SELECT *
FROM fastfood
WHERE sido = '��⵵'
AND sigungu = '������';



SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;


SELECT sido, sigungu, ROUND((kfc+����ŷ+mac)/�Ե�����,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '����ŷ', 1)),0)����ŷ,
            NVL(SUM(DECODE(gb, '�Ƶ�����', 1)),0) mac, NVL(SUM(DECODE(gb, '�Ե�����', 1)),1)�Ե�����
        FROM fastfood
        WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
        GROUP BY sido, sigungu)
ORDER BY score desc;

-- �ܹ��� ���� �õ�, �ܹ�������, �ñ���, �ܹ�������, ���� �õ�, ���� �ñ���, ���κ� �ٷ� �ҵ��
-- ROWNUM ���� ������ �ϸ� �� ���̺��� 1���� ���ÿ� ��µǰ� �Ҽ� �ִ�.

--  ROWNUM ���� ����
--   1. SELECT --> ORDER BY
--      ���ĵ� ����� ROWNUM�� �����ϱ� ���ؼ��� INLINE_VIEW
--   2. 1������ ���������� ��ȸ�� �Ǵ� ���ǿ��� WHERE������ ����� ����
--      ROWNUM = 1 (O), ROWNUM = 2(X), ROWNUM < 10 (o), ROUNUM > 10 (X)

SELECT a.sido, a.sigungu, a.ham_score, b.sido, b.sigungu, b.pri_sal
FROM
(
    (SELECT ROWNUM rm1, sido,sigungu,ham_score
    FROM
        (SELECT sido, sigungu,
        ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0) + NVL(SUM(DECODE(gb, '����ŷ', 1)),0)+
               NVL(SUM(DECODE(gb, '�Ƶ�����', 1)),0) )/ NVL(SUM(DECODE(gb, '�Ե�����', 1)),1),2) ham_score
        FROM fastfood
        WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
        GROUP BY sido, sigungu
        ORDER BY ham_score DESC)
        
    )a

JOIN

    (SELECT ROWNUM rm2, sido, sigungu, pri_sal
    FROM
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax))b
        
ON(a.rm1 = b.rm2))
ORDER BY b.pri_sal desc;    


desc dept;

--DML
--emp�÷��� NOT NULL ���������� �ִ�. -> INSERT �� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�.
--empno �÷��� ������ ������ �÷��� NULLABLE�̴�. (NULL���� ����� �� �ִ�.)
INSERT INTO emp (empno, ename, job) VALUES (9999,'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job) VALUES ('sally','SALESMAN');

--���ڿ� : '���ڿ�' 
--���� : 10
--��¥ : TO_DATE('20200206','YYYY/MM/DD'), SYSDATE

--emp ���̺��� hiredate �÷��� date Ÿ��
--emp ���̺��� 8�� �÷��� ���� �Է�

DESC emp;
INSERT INTO emp VALUES(9998,'sally','SALESMAN',NULL,SYSDATE,1000,NULL,99);

ROLLBACK;

--�������� �����͸� �ѹ��� INSERT
--INSERT INTO ���̺�� (�÷���1, �÷���2.....)
--SELECT ..
--FROM
--SELECT ����� ���̺� ����.


INSERT INTO emp
SELECT 9998,'sally','SALESMAN',NULL,SYSDATE,1000,NULL,99
FROM dual
    UNION ALL
SELECT 9999,'brown','CLERK',NULL,TO_DATE('20200205','YYYYMMDD'),1100,NULL,99
FROM dual;

SELECT *
FROM emp;

--UPDATE
--WHERE ���� ���ٸ� ���� ������ ��Ȳ�̴� --> ������� ������� update�� �ϰڴٴ� ����
--UPDATE ���̺�� set �÷���1 = ������ �÷���1, �÷���2= ������ �÷� ��2....
--UPDATE, DELETE ���� WHERE ���� ������ �ǵ��Ѱ� �´��� �ٽ��ѹ� Ȯ���Ѵ�.
--WHERE ���� �ִٰ� �ϴ��� �ش��������� �ش� ���̺��� SELECT�ϴ� ������ �ۼ��Ͽ� �����ϸ� UPDATE ��� ���� ��ȸ �� ��
--�����Ƿ� Ȯ���ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�.

--99�� �μ���ȣ�� ���� �μ� ������ DEPT���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99,'DDIT','daejeon');

--99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���it', loc �÷��� ���� '���κ���'���� ������Ʈ�Ѵ�.

UPDATE dept SET dname = '���IT', loc= '���κ���'
WHERE deptno = '99';

select *
FROM dept;

ROLLBACK;

--�Ǽ��� WHERE���� ������� �ʾ��� ���
UPDATE dept SET dname = '���IT', loc = '���κ���';


-- 10--> SUBQUERY
--SMITH, WARD�� ���� �μ��� �Ҽӵ� ���� ����
SELECT*
FROM emp
WHERE deptno IN (20,30);

SELECT*
FROM emp
WHERE deptno IN 
                (SELECT deptno
                 FROM emp
                 WHERE ename  IN ('SMITH','WARD'));

--UPDATE�ÿ��� ������������� ����
INSERT INTO emp (empno, ename) VALUES(9999, 'brown');
--9999�� ��� deptno, job������ SMITH ����� ���� �μ�����, �������� ������Ʈ

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno=9999;

SELECT *
FROM emp;

ROLLBACK;


--DELETE SQL : Ư�� ���� ����
--DELETE [FROM] ���̺�� WHERE ������ ����

--99�� �μ���ȣ�� �ش��ϴ� �μ� ���� ����

DELETE dept 
WHERE deptno = '99';

SELECT *
FROM dept;
COMMIT;

--SUBQUERY�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
--�Ŵ����� 7698����� ������ �����ϴ� ������ �ۼ�

DELETE EMP
WHERE empno IN (SELECT empno FROM emp WHERE mgr = '7698') ;
rollback;

