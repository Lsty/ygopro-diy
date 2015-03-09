--埋伏具 骤雨投射
function c2222224.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c2222224.cost)
	e1:SetCondition(c2222224.condition)
	e1:SetTarget(c2222224.destg)
	e1:SetOperation(c2222224.desop)
	c:RegisterEffect(e1)
     --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCost(c2222224.scost)
	e2:SetTarget(c2222224.tg)
	e2:SetCountLimit(1,2222224)
	e2:SetOperation(c2222224.activate)
	c:RegisterEffect(e2)
	--search2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2222224,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c2222224.thcost)
	e3:SetTarget(c2222224.target)
	e3:SetOperation(c2222224.operation)
	c:RegisterEffect(e3)
end
function c2222224.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c2222224.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2222224.hfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2222224.cfilter(c)
	return c:IsCode(2222222) and c:IsDiscardable()
end
function c2222224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222224.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c2222224.cfilter,1,1,REASON_COST+REASON_DISCARD)
      Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c2222224.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0,nil)
end
function c2222224.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c2222224.scfilter(c,e,tp)
	return c:IsSetCard(0x203) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2222224.sccfilter(c)
	return c:IsCode(2222232) and c:IsDiscardable()
end
function c2222224.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(c2222224.sccfilter,tp,LOCATION_HAND,0,1,nil) end
		Duel.DiscardHand(tp,c2222224.sccfilter,1,1,REASON_COST+REASON_DISCARD)
		       Duel.PayLPCost(tp,2000) 
end
function c2222224.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c2222224.scfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c2222224.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(c2222224.scfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c2222224.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c2222224.thfilter(c)
	return c:IsSetCard(0x203) and c:IsAbleToHand()
end
function c2222224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222224.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2222224.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2222224.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end