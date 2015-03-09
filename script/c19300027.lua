--镜现诗·境界的妖怪
function c19300027.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19300027.codisable)
	e1:SetCost(c19300027.cost)
	e1:SetTarget(c19300027.target)
	e1:SetOperation(c19300027.operation)
	c:RegisterEffect(e1)
end
function c19300027.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c19300027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19300027.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19300027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT)
		if tc:IsFaceup() and tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x193) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCountLimit(1)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCondition(c19300027.spcon)
			e1:SetOperation(c19300027.spop)
			e1:SetLabelObject(tc)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			Duel.RegisterEffect(e1,tp)
			tc:RegisterFlagEffect(19300027,RESET_EVENT+0x1fe0000,0,0)
		end
	end
end
function c19300027.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp
		and tc:GetFlagEffect(19300027)~=0 and tc:GetReasonEffect():GetHandler()==e:GetHandler()
end
function c19300027.mfilter(c)
	return c:IsSetCard(0x193) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c19300027.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SpecialSummon(e:GetLabelObject(),0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c19300027.mfilter,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=g:Select(tp,2,2,nil)
			Duel.HintSelection(mg)
			Duel.Overlay(e:GetLabelObject(),mg)
		end
	end
end