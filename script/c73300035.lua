--血之梦魇 蕾米莉亚·斯卡雷特
function c73300035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c73300035.xyzfilter,4,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c73300035.cost)
	e1:SetTarget(c73300035.target)
	e1:SetOperation(c73300035.operation)
	c:RegisterEffect(e1)
	--indestructable by effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c73300035.xyzfilter(c)
	return c:IsSetCard(0x733) or c:IsSetCard(0x877) or c:GetCode()==73300034 or c:GetCode()==87700018
end
function c73300035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c73300035.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c73300035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c73300035.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c73300035.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c73300035.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c73300035.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			if (tc:IsSetCard(0x733) or tc:IsSetCard(0x877) or tc:GetCode()==73300034 or tc:GetCode()==87700018)
				and tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(73300035,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.HintSelection(dg)
				Duel.SendtoHand(dg,nil,REASON_EFFECT)
			end
			Duel.ShuffleHand(tp)
		end
	end
end