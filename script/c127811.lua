--「刻刻帝」 四之弹（Dalet）
function c127811.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c127811.cost)
	e1:SetTarget(c127811.target)
	e1:SetOperation(c127811.activate)
	c:RegisterEffect(e1)
end
function c127811.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fd=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd and fd:IsCode(127808) and fd:IsCanRemoveCounter(c:GetControler(),0x16,3,REASON_COST) end
	local fd=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	fd:RemoveCounter(tp,0x16,3,REASON_RULE)
end
function c127811.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x9fa) and c:IsFaceup()
end
function c127811.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9fa) and c:IsType(TYPE_MONSTER)
end
function c127811.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c127811.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c127811.filter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingTarget(c127811.filter2,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SelectTarget(tp,c127811.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c127811.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c127811.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end
