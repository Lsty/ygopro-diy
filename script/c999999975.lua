--宝具 螺涅城教本
function c999999975.initial_effect(c)
	c:SetUniqueOnField(1,0,999999975)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999975.target)
	e1:SetOperation(c999999975.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999975.eqlimit)
	c:RegisterEffect(e2)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999975,0))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c999999975.rcon)
	e5:SetOperation(c999999975.rop)
	c:RegisterEffect(e5)
	--equip effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(999999975)
	c:RegisterEffect(e3)
end
function c999999975.eqlimit(e,c)
	return  c:IsCode(999999996) 
end
function c999999975.filter(c)
	return c:IsFaceup() and c:IsCode(999999996) 
end
function c999999975.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999975.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999975.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999975.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999975.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c999999975.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ)
		and ep==e:GetOwnerPlayer() and e:GetHandler():GetEquipTarget()==re:GetHandler() and re:GetHandler():GetOverlayCount()>=ev-1
end
function c999999975.rop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=bit.band(ev,0xffff)
	if ct<10 then
		Duel.RemoveOverlayCard(tp,1,0,0,0,REASON_COST)
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
