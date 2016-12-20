--Witchcrafter Alexis
function c77777707.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777707.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777707,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetDescription(aux.Stringid(77777707,0))
	e3:SetCountLimit(1)
	e3:SetCondition(c77777707.sccon)
--	e3:SetTarget(c77777707.sctg)
	e3:SetOperation(c77777707.scop)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(-200)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x407))
	e5:SetValue(200)
	c:RegisterEffect(e5)
	--Special Summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetRange(LOCATION_HAND)
	e7:SetCountLimit(1,77777707)
	e7:SetDescription(aux.Stringid(77777707,1))
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e7:SetTargetRange(POS_FACEUP,0)
	e7:SetCondition(c77777707.spcon2)
	c:RegisterEffect(e7)
	--spsummon grave
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetDescription(aux.Stringid(77777707,2))
	e8:SetCountLimit(1,77777807)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetTarget(c77777707.sptg)
	e8:SetOperation(c77777707.spop)
	c:RegisterEffect(e8)
end

function c77777707.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0x407) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0x407)
end

function c77777707.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777707.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777707.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end

function c77777707.spfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777707.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777707.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777707.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777707.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777707.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
