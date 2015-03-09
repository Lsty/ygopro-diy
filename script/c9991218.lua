--神天龙-太阴龙
function c9991218.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Fuck Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991218,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991218)
	e1:SetCondition(c9991218.con1)
	e1:SetCost(c9991218.cost1)
	e1:SetTarget(c9991218.tg1)
	e1:SetOperation(c9991218.op1)
	c:RegisterEffect(e1)
	--Summon Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9991218.sltg)
	c:RegisterEffect(e2)
end
function c9991218.con1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return Duel.GetCurrentPhase()==PHASE_BATTLE else return true end
end
function c9991218.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9991218.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c9991218.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9991218.sltg(e,c,sump,sumtype,sumpos,targetp)
	return sumtype==SUMMON_TYPE_XYZ
end