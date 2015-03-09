--里 清月
function c2222223.initial_effect(c)
	c:SetUniqueOnField(1,0,2222223)
	--skr summon
      aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,2222230),aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
      local e2=Effect.CreateEffect(c)
      e2:SetDescription(aux.Stringid(2222223,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,2222223)
	e2:SetCondition(c2222223.setcon)
	e2:SetTarget(c2222223.settg)
	e2:SetOperation(c2222223.setop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2222223,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,2222299)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c2222223.sgcost)
	e3:SetTarget(c2222223.sgtg)
	e3:SetOperation(c2222223.sgop)
	c:RegisterEffect(e3)
	--
	--[[local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2222223,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c2222223.discon)
	e4:SetCost(c2222223.discost)
	e4:SetTarget(c2222223.distg)
	e4:SetOperation(c2222223.disop)
	c:RegisterEffect(e4)]]
end
function c2222223.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c2222223.filter(c)
	return c:IsSetCard(0x234) and c:IsSSetable()
end
function c2222223.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c2222223.filter,tp,LOCATION_DECK,0,2,nil) end
end
function c2222223.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c2222223.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
            Duel.SSet(tp,g:GetNext())
		Duel.ConfirmCards(1-tp,g)
end
end
function c2222223.costfilter(e,te)
	return e:GetType()==0x4
end
function c2222223.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222223.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c2222223.costfilter,1,1,REASON_COST+REASON_DISCARD)
end

function c2222223.sgfilter(c)
	return c:IsType(TYPE_TRAP)  and c:IsAbleToRemove()
end
function c2222223.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c2222223.sgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c2222223.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c2222223.sgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
   end
end
function c2222223.disfilter(c)
     return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c2222223.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222223.disfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c2222223.disfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c2222223.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and Duel.IsChainNegatable(ev)
end
function c2222223.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c2222223.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		end
	end
