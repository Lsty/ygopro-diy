--怪物猎人 丸鸟
function c11112000.initial_effect(c)
    --1 token
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11112000)
	e1:SetTarget(c11112000.sptg)
	e1:SetOperation(c11112000.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--2 token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11112000,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11112000)
	e3:SetCondition(c11112000.tkcon)
	e3:SetTarget(c11112000.tktg)
	e3:SetOperation(c11112000.tkop)
	c:RegisterEffect(e3)
end
function c11112000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAttackPos()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11112008,0x15b,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_EARTH) end	
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11112000.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsDefencePos() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   and Duel.IsPlayerCanSpecialSummonMonster(tp,11112008,0x15b,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_EARTH) then
	    Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
		local token=Duel.CreateToken(tp,11112008)
	    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	    e1:SetValue(1)
	    e1:SetReset(RESET_EVENT+0x1fe0000)
	    token:RegisterEffect(e1,true)
	    Duel.SpecialSummonComplete()   
	end
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function c11112000.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end	
function c11112000.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11112008,0x15b,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_EARTH) end	
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c11112000.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	   and Duel.IsPlayerCanSpecialSummonMonster(tp,11112008,0x15b,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_EARTH) then
	    for i=1,2 do
		    local token=Duel.CreateToken(tp,11112008)
		    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
		    e1:SetValue(1)
		    token:RegisterEffect(e1,true)
	    end
	    Duel.SpecialSummonComplete()
	end	
end