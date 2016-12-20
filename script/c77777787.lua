--Hellformed Aetherial Descendant, Satsuji
function c77777787.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777787.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777787,2))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777787.scop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777787,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,77777787)
	e4:SetCondition(c77777787.spcon)
	e4:SetOperation(c77777787.spop)
	c:RegisterEffect(e4)
	--attack twice
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777787,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,77777786+EFFECT_COUNT_CODE_OATH)
	e6:SetCost(c77777787.spcost)
	e6:SetTarget(c77777787.sptg)
	e6:SetOperation(c77777787.spop2)
	c:RegisterEffect(e6)
	--cannot direct attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
end

function c77777787.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_FIEND)or c:IsRace(RACE_SPELLCASTER)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777787.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777787.spfilter(c,e,tp)
	return (c:IsSetCard(0x3e7)or c:IsSetCard(0x144)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777787.spcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0x3e7) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0x3e7)
end
function c77777787.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777787.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77777787.filter(c,e,tp)
	return c:IsCode(66666617) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c77777787.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77777787.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777787.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
