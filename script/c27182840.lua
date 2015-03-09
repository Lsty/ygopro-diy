--暗中微弱的希望 莉格露
function c27182840.initial_effect(c)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(27182840,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27182840)
	e2:SetCost(c27182840.thcost)
	e2:SetTarget(c27182840.thtg)
	e2:SetOperation(c27182840.thop)
	c:RegisterEffect(e2)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27182840,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetOperation(c27182840.ctop)
	c:RegisterEffect(e4)
end
function c27182840.cfilter(c,lv)
	return c:GetRank()==lv and c:IsFaceup()
end
function c27182840.ctop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetBattleTarget():GetLevel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,lv do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27182840,1))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0xf,1)
	end
end
function c27182840.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0xf,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0xf,3,REASON_COST)
end
function c27182840.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c27182840.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end