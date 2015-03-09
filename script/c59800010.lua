--抚子·美杜莎
function c59800010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59800010,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c59800010.cost)
	e1:SetTarget(c59800010.thtg)
	e1:SetOperation(c59800010.thop)
	c:RegisterEffect(e1)
end
function c59800010.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c59800010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59800010.tgfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c59800010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c59800010.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59800010.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c59800010.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingTarget(c59800010.tgfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c59800010.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c59800010.sumlimit)
		e1:SetLabel(tc:GetCode())
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
		if Duel.IsExistingMatchingCard(c59800010.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(59800010,1)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c59800010.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_COST)
		end
	end
end
function c59800010.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end