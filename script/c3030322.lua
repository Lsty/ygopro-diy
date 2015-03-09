--女仆长 莉莉亚娜
function c3030322.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_PSYCHO),1)
	c:EnableReviveLimit()
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13959634,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,3030322)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c3030322.tg)
	e1:SetOperation(c3030322.op)
	c:RegisterEffect(e1)
end
function c3030322.filter(c,e,tp)
	return  c:IsSetCard(0xaabb)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3030322.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingMatchingCard(c3030322.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(3030322,1),aux.Stringid(3030322,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(3030322,1))
	else op=Duel.SelectOption(tp,aux.Stringid(3030322,2))+1 end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*300)
	end
end
function c3030322.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3030322.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local sg=Duel.GetDecktopGroup(1-tp,1)
	local tc=sg:GetFirst()
	Duel.Draw(1-tp,2,REASON_EFFECT)
	else
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*300,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end