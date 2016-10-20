--ANTI-MATTER Dark Being, Rokkr
function c1143227.initial_effect(c)
	c:SetUniqueOnField(1,0,1143227)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143227.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c1143227.actcon)
	e4:SetValue(c1143227.actlimit)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1143227,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,1143227)
	e5:SetCondition(c1143227.spcon)
	e5:SetTarget(c1143227.sptg)
	e5:SetOperation(c1143227.spop)
	c:RegisterEffect(e5)
	if not c1143227.global_check then
		c1143227.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143227))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143227.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143227.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143227.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143227.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c1143227.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c1143227.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c1143227.spfilter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and lv<8 and c:IsSetCard(0xaf75) and not c:IsCode(1143227) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1143227.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp,8-lv)
end
function c1143227.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0xaf75) and c:GetLevel()==lv and not c:IsCode(1143227) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143227.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143227.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143227.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c1143227.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c1143227.spfilter2,tp,LOCATION_DECK,0,1,1,tc1,e,tp,8-tc1:GetLevel())
	g1:Merge(g2)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	Duel.Draw(tp,1,REASON_EFFECT)
end
