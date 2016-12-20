--Hellformed Girl Twilight
function c77777761.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777761,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77777761)
	e2:SetTarget(c77777761.sptg)
	e2:SetOperation(c77777761.spop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c77777761.splimit)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetDescription(aux.Stringid(77777761,1))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c77777761.matcon)
	e5:SetOperation(c77777761.matop)
	c:RegisterEffect(e5)
end

function c77777761.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FIEND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777761.spfilter(c,e,tp)
	return c:IsSetCard(0x3e7) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777761.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c77777761.spfilter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c77777761.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777761.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777761.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	local me=e:GetHandler()
	local dg=Group.FromCards(g,me)
	local sg=dg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

function c77777761.matcon(e,tp,eg,ep,ev,re,r,rp)
	return (r==REASON_RITUAL or r==REASON_SYNCHRO or r==REASON_FUSION) and not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
		and e:GetHandler():GetReasonCard():IsSetCard(0x3e7)
end
function c77777761.matop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end