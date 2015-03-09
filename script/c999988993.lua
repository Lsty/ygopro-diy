--First Folio
function c999988993.initial_effect(c)
	c:SetUniqueOnField(1,0,999988993)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999988993.target)
	e1:SetOperation(c999988993.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999988993.eqlimit)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c999988993.destg)
	e3:SetValue(c999988993.value)
	e3:SetOperation(c999988993.desop)
	c:RegisterEffect(e3)
end
function c999988993.eqlimit(e,c)
	return  c:IsCode(999988994)
end
function c999988993.filter(c)
	return c:IsFaceup() and c:IsCode(999988994)  
end
function c999988993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999988993.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999988993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999988993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999988993.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999988993.dfilter(c)
	return  c:IsReason(REASON_BATTLE)
end
function c999988993.repfilter(c)
	return  c:IsAbleToGrave()
end
function c999988993.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c999988993.dfilter,1,nil)
		and Duel.IsExistingMatchingCard(c999988993.repfilter,tp,LOCATION_HAND,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(999997,6))
end
function c999988993.value(e,c)
	return  c:IsReason(REASON_BATTLE)
end
function c999988993.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c999988993.repfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
