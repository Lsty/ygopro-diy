--神天龙-岚龙
function c9991212.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),true)
	--DD Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991212,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991212)
	e1:SetCondition(c9991212.spcon)
	e1:SetTarget(c9991212.sptg)
	e1:SetOperation(c9991212.spop)
	c:RegisterEffect(e1)
	--Traping Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991212,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9991212)
	e2:SetCondition(c9991212.spcon)
	e2:SetTarget(c9991212.tmtg)
	e2:SetOperation(c9991212.tmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Summon Limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c9991212.sumsuc)
	c:RegisterEffect(e4)
end
function c9991212.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9991212.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function c9991212.spfilter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991212.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991212.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and eg:IsExists(c9991212.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991212.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991212.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP)
	end
end
function c9991212.tmfilter1(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsAbleToHand()
end
function c9991212.tmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9991212.tmfilter1,1,nil,tp) end
	local g=eg:Filter(c9991212.tmfilter1,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991212.tmfilter2(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsAbleToHand() and c:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e)
end
function c9991212.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9991212.tmfilter2,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c9991212.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991212.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991212.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_FUSION)>0
end
