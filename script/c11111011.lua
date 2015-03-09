--世界的本源 世界树
function c11111011.initial_effect(c)
    c:SetUniqueOnField(1,0,11111011)
    --xyz summon
    aux.AddXyzProcedure(c,nil,10,3,c11111011.ovfilter,aux.Stringid(11111011,0))
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c11111011.condition)
	e1:SetCost(c11111011.cost)
	e1:SetTarget(c11111011.target)
	e1:SetOperation(c11111011.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c11111011.reptg)
	c:RegisterEffect(e2)
end
function c11111011.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==9
	    and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function c11111011.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()<=3
end	
function c11111011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsDirectAttacked() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	e:GetHandler():RegisterEffect(e1)
end	
function c11111011.filter(c)
    return c:IsAbleToChangeControler()
end
function c11111011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c11111011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111011.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11111011.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c11111011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end	
function c11111011.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(11111011,1)) then
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_EFFECT)
		return true
	else return false end
end