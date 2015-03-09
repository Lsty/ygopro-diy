--君主XIII 灵魂的塔玛西
function c11111022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111022,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11111022.cost)
	e1:SetTarget(c11111022.target)
	e1:SetOperation(c11111022.operation)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111022,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11111022+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c11111022.mtcost)
	e2:SetTarget(c11111022.mttg)
	e2:SetOperation(c11111022.mtop)
	c:RegisterEffect(e2)
end	
function c11111022.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11111022.filter(c)
	return c:IsRankBelow(5) and c:IsAbleToRemoveAsCost()
end
function c11111022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and c11111022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111022.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11111022.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end	
function c11111022.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
	    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(tc:GetAttack())
		c:RegisterEffect(e2)
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END, 1)
	end
end
function c11111022.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c11111022.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11111022.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111022.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11111022.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11111022.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end	