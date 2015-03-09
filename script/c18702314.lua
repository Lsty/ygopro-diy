--操鸟师 纸鹤
function c18702314.initial_effect(c)
    --DAMAGE
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,18702314)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetTarget(c18702314.damtg)
	e1:SetOperation(c18702314.damop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73176465,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,187023140)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c18702314.condtion)
	e1:SetTarget(c18702314.rmtg)
	e1:SetOperation(c18702314.rmop)
	c:RegisterEffect(e1)
end
function c18702314.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x257) and c:IsAbleToGrave()
end
function c18702314.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702314.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18702314.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702314.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18702314.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
		and re:GetHandler():IsSetCard(0x257)
end
function c18702314.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18702314.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if Duel.SpecialSummonStep(c,257,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(TYPE_TUNER)
			c:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
function c18702314.tpval(e,c)
	if c:IsFaceup() then return TYPE_EFFECT+TYPE_MONSTER+TYPE_TUNER
	else return TYPE_EFFECT+TYPE_MONSTER end
end