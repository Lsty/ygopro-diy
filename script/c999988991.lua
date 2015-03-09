--我的上帝在此
function c999988991.initial_effect(c)
	c:SetUniqueOnField(1,0,999988991)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999988991.target)
	e1:SetOperation(c999988991.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999988991.eqlimit)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c999988991.ind)
	e3:SetTarget(c999988991.tg)
	c:RegisterEffect(e3)
end
function c999988991.eqlimit(e,c)
	return  c:IsCode(999988992)  or c:IsCode(999988990) 
end
function c999988991.filter(c)
	return c:IsFaceup() and  (c:IsCode(999988992)  or c:IsCode(999988990)) 
end
function c999988991.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999988991.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999988991.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999988991.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999988991.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999988991.ind(e,re,tp)
	return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and  e:GetHandlerPlayer()==1-tp
end
function c999988991.tg(e,c)
	return  c:IsFaceup()
end