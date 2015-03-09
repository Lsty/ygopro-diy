--Dragon★Slayer
function c20121112.initial_effect(c)
	--remove oth
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c20121112.con)
	e3:SetTarget(c20121112.destg)
	e3:SetOperation(c20121112.desop)
	c:RegisterEffect(e3)
end
function c20121112.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c20121112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
end
function c20121112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local tg=g:RandomSelect(1-tp,1)
	local sg=tg:GetFirst()
	Duel.ConfirmCards(tp,sg)
	if sg:IsType(TYPE_EFFECT) and sg:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(20121112,0)) then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end