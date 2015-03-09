--怪物猎人 霸龙
function c11112042.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),1)
	c:EnableReviveLimit()
	--cannot return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112042,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c11112042.rtcost)
	e1:SetTarget(c11112042.rttg)
	e1:SetOperation(c11112042.rtop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112042,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c11112042.descon)
	e2:SetTarget(c11112042.destg)
	e2:SetOperation(c11112042.desop)
	c:RegisterEffect(e2)
end
function c11112042.rtfilter(c)
	return c:IsSetCard(0x15b) and c:IsDiscardable()
end
function c11112042.rtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112042.rtfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11112042.rtfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c11112042.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c11112042.rtop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	Duel.RegisterEffect(e2,tp)
end
function c11112042.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c11112042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c11112042.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end