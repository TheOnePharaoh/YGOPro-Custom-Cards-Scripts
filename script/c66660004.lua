--Horned Dragonsbane - Eternal Sin
--coded by Chadook
function c66660004.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c66660004.sumop)
	c:RegisterEffect(e1)
		--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(66660004,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,66660004)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c66660004.sctg)
	e3:SetOperation(c66660004.scop)
	c:RegisterEffect(e3)
end
function c66660004.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,78364471)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4c2))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,78364471,RESET_PHASE+PHASE_END,0,1)
end

function c66660004.filter(c,e,tp,m)
return  c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c66660004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c66660004.filter1(c,e,tp,cg)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and cg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end

function c66660004.filter(c,e,tp,lv)
return c:IsFaceup() and c:GetLevel()>0
and Duel.IsExistingMatchingCard(c66660004.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv+c:GetOriginalLevel())
end
function c66660004.scfilter(c,e,tp,lv)
return c:GetLevel()<=lv and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c66660004.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return false end
local lv=e:GetHandler():GetOriginalLevel()
if chk==0 then return Duel.IsExistingTarget(c66660004.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,lv) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectTarget(tp,c66660004.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,lv)
g:AddCard(e:GetHandler())
Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c66660004.scop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=Duel.GetFirstTarget()
if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
local g=Group.FromCards(c,tc)
if Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==2 and c:GetLevel()>0 and c:IsLocation(LOCATION_GRAVE)
and tc:GetLevel()>0 and tc:IsLocation(LOCATION_GRAVE) then
local lv=c:GetLevel()+tc:GetLevel()
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local sg=Duel.SelectMatchingCard(tp,c66660004.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv)
local tc=sg:GetFirst()
if tc then
Duel.BreakEffect()
tc:SetMaterial(g)
Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
tc:CompleteProcedure()
end
end
end