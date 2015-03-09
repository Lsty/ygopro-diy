--女仆少女 芭莲希雅
function c3030326.initial_effect(c)
	--burn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20663556,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3030326)
	e1:SetCost(c3030326.cost)
	e1:SetTarget(c3030326.damtg)
	e1:SetOperation(c3030326.damop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69000994,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c3030326.condition)
	e2:SetTarget(c3030326.sptg)
	e2:SetOperation(c3030326.spop)
	c:RegisterEffect(e2)
end
function c3030326.cfilter(c,e,tp)
	return c:IsSetCard(0xaabb)
end
function c3030326.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c3030326.cfilter,1,nil) and Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==1 then 
		Duel.DiscardDeck(tp,1,REASON_COST)
		e:SetLabel(1)
	else
		local ac=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,2))
		if ct==2 then ac=Duel.AnnounceNumber(tp,1,2)
		else ac=Duel.AnnounceNumber(tp,1,2,3) end
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
	local g=Duel.SelectReleaseGroup(tp,c3030326.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	local lv=0
	local tc=g:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=g:GetNext()
	end
	e:SetLabel(lv)
end
function c3030326.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(1-tp)
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*ct*100)
end
function c3030326.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetLabel()
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*ct*100,REASON_EFFECT)
end
function c3030326.ccfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c3030326.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c3030326.ccfilter,1,nil,1-tp)
end
function c3030326.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3030326.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end