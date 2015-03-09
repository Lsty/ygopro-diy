--魔人少女 色欲之露西莉亚
function c30303021.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52687916,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c30303021.remcon)
	e1:SetCost(c30303021.cost)
	e1:SetTarget(c30303021.remtg)
	e1:SetOperation(c30303021.remop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c30303021.efilter)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c30303021.ind2)
	c:RegisterEffect(e2)
end
function c30303021.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c30303021.costfilter(c)
	return c:IsSetCard(0xabb) and c:IsReleasable()
end
function c30303021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c30303021.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectTarget(tp,c30303021.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,3,nil)
	ct=Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function c30303021.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c30303021.remop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD+LOCATION_HAND,ct,ct,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c30303021.ind2(e,c)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_BEAST or c:GetRace()==RACE_BEASTWARRIOR or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end
function c30303021.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (re:GetHandler():GetRace()==RACE_WARRIOR or re:GetHandler():GetRace()==RACE_SPELLCASTER or re:GetHandler():GetRace()==RACE_ZOMBIE or re:GetHandler():GetRace()==RACE_MACHINE
	or re:GetHandler():GetRace()==RACE_AQUA or re:GetHandler():GetRace()==RACE_PYRO or re:GetHandler():GetRace()==RACE_ROCK or re:GetHandler():GetRace()==RACE_WINDBEAST
	or re:GetHandler():GetRace()==RACE_PLANT or re:GetHandler():GetRace()==RACE_INSECT or re:GetHandler():GetRace()==RACE_THUNDER or re:GetHandler():GetRace()==RACE_DRAGON
	  or re:GetHandler():GetRace()==RACE_BEAST or re:GetHandler():GetRace()==RACE_BEASTWARRIOR or re:GetHandler():GetRace()==RACE_DINOSAUR or re:GetHandler():GetRace()==RACE_FISH
	  or re:GetHandler():GetRace()==RACE_SEASERPENT  or re:GetHandler():GetRace()==RACE_REPTILE  or re:GetHandler():GetRace()==RACE_PSYCHO  or re:GetHandler():GetRace()==RACE_DEVINE
	  or re:GetHandler():GetRace()==RACE_CREATORGOD  or re:GetHandler():GetRace()==RACE_WYRM)

end